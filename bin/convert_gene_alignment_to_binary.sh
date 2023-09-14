#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAME=$1
geneCov1=$2
geneCov2=$3
geneIden1=$4
geneIden2=$5
geneLen=$6
output=$7
input=$8

echo "Gene" > ${input}/tmp_column_000_gene_names.txt

# remove all the short genes from the clustered genes file
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' ${output}/output_results/clustered_genes_${NAME}.ffn > ${input}/clustered_temp_${NAME}

awk -v len="$geneLen" 'BEGIN {RS = ">" ; ORS = ""} length($2) > len {print ">"$0}' ${input}/clustered_temp_${NAME} > ${input}/clustered_noshort_${NAME}

rm -f ${input}/clustered_temp_${NAME}

LANG=C grep ">" ${input}/clustered_noshort_${NAME} | sed 's/>//g'  >> ${input}/tmp_column_000_gene_names.txt
LANG=C grep ">" ${input}/clustered_noshort_${NAME} | sed 's/>//g' > ${input}/tmp_genelist

# make variable gene list
cat ${output}/output_results/sample_gene_stats/*_db_gene_presence.txt | awk '$7==1 {print $2}' | sort | uniq > ${input}/temp_variable_genes

convert_to_binary() {
	line=$1
        linename=$(basename ${line})
	echo ${line} > ${input}/tmp_column_${linename}.txt
        # remove all the short genes from the gene presence file
        awk -v len=$geneLen '{if($3>len) print $0}' ${output}/output_results/sample_gene_stats/${linename}_db_gene_presence.txt > ${output}/output_results/${linename}_tmp

        #check for the variable genes
        while read gene
        do
                if grep -qFx $gene ${input}/temp_variable_genes
                then
                        cat ${output}/output_results/${linename}_tmp | grep -wF $gene | awk -v cov1=$geneCov1 -v cov2=$geneCov2 -v iden1=$geneIden1 -v iden2=$geneIden2 '{if ($6>=iden1 && $5>=cov1) print "1"; else if ($6>=iden2 && $5>=cov2) print "1"; else print "0"}' >> ${input}/tmp_column_${linename}.txt
                else
                        echo "1" >> ${input}/tmp_column_${linename}.txt
                fi
	done < ${input}/tmp_genelist
	
	rm -f ${output}/output_results/${linename}_tmp
}


while read line
do
	convert_to_binary $line $

done < ${output}/output_results/sample_list.txt
wait

paste ${input}/tmp_column_*.txt > ${output}/output_results/gene_presence_absence_${NAME}.txt
