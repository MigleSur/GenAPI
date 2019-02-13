#!/bin/bash

NAME=$1
geneCov1=$2
geneCov2=$3
geneIden1=$4
geneIden2=$5
geneLen=$6


echo "Gene" > tmp_column_000_gene_names.txt

# remove all the short genes from the clustered genes file
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' output_results/clustered_genes_${NAME}.ffn > clustered_temp_${NAME}

awk -v len="$geneLen" 'BEGIN {RS = ">" ; ORS = ""} length($2) > len {print ">"$0}' clustered_temp_${NAME} > clustered_noshort_${NAME}

rm -f clustered_temp_${NAME}

LANG=C grep ">" clustered_noshort_${NAME} | sed 's/>//g'  >> tmp_column_000_gene_names.txt
LANG=C grep ">" clustered_noshort_${NAME} | sed 's/>//g' > tmp_genelist

# make variable gene list
cat output_results/sample_gene_stats/*_db_gene_presence.txt | awk '$7==1 {print $2}' | sort | uniq > temp_variable_genes

convert_to_binary() {
	line=$1
	echo ${line} > tmp_column_${line}.txt

        # remove all the short genes from the gene presence file
        awk -v len=$geneLen '{if($3>len) print $0}' output_results/sample_gene_stats/${line}_db_gene_presence.txt > output_results/${line}_tmp

        #check for the variable genes
        while read gene
        do
                if grep -qFx $gene temp_variable_genes
                then
                        cat output_results/${line}_tmp | grep -wF $gene | awk -v cov1=$geneCov1 -v cov2=$geneCov2 -v iden1=$geneIden1 -v iden2=$geneIden2 '{if ($6>=iden1 && $5>=cov1) print "1"; else if ($6>=iden2 && $5>=cov2) print "1"; else print "0"}' >> tmp_column_${line}.txt
                else
                        echo "1" >> tmp_column_${line}.txt
                fi
	done < tmp_genelist
	
	rm -f output_results/${line}_tmp
}


while read line
do
	convert_to_binary $line $

done < output_results/sample_list.txt
wait

paste tmp_column_*.txt > output_results/gene_presence_absence_${NAME}.txt
