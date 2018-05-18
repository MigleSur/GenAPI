#!/bin/bash

NAME=$1

rm -f output_results/gene_presence_absence_${NAME}.txt
rm -f tmp_column_000_gene_names.txt
echo "Gene" > tmp_column_000_gene_names.txt

# remove all the short genes from the clustered genes file
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' output_results/clustered_genes_${NAME}.ffn > clustered_temp_${NAME}

awk 'BEGIN {RS = ">" ; ORS = ""} length($2) > 150 {print ">"$0}' clustered_temp_${NAME} > clustered_noshort_${NAME}

rm -f clustered_temp_${NAME}

grep ">" clustered_noshort_${NAME} | sed 's/>//g'  >> tmp_column_000_gene_names.txt
grep ">" clustered_noshort_${NAME} | sed 's/>//g' > tmp_genelist

# make variable gene list
cat output_results/sample_gene_stats/*_db_gene_presence.txt | awk '$7==1 {print $2}' | sort | uniq > temp_variable_genes

while read line
do

	echo ${line} >> tmp_column_${line}.txt

	# remove all the short genes from the gene presence file
	awk '{if($3>150) print $0}' output_results/sample_gene_stats/${line}_db_gene_presence.txt > output_results/${line}_tmp

	#check for the variable genes
	while read gene
	do
		if grep -qFx $gene temp_variable_genes
		then
			cat output_results/${line}_tmp | grep -F $gene | awk '{if ($6>=90 && $5>=0.5) print "1"; else if ($6>=98 && $5>=0.25) print "1"; else print "0"}' >> tmp_column_${line}.txt
		else
			echo "1" >> tmp_column_${line}.txt
		fi
	
	done < tmp_genelist

	rm -f output_results/${line}_tmp

done < output_results/sample_list.txt

paste tmp_column_*.txt > output_results/gene_presence_absence_${NAME}.txt

rm -f tmp_genelist
rm -f tmp_column_*.txt
rm -f output_results/sample_list.txt
rm -f clustered_noshort_${NAME}
rm -f temp_variable_genes
rm -rf output_results/sample_blast_results
