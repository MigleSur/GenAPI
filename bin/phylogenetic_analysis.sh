#!/bin/bash

NAME=$1

mkdir -p output_results/phylogenetic_analysis
rm -f output_results/phylogenetic_analysis/*.${NAME}

while read file 
do
	cat tmp_column_${file}.txt | awk 'NR==1{print}NR>1{sub(/\n/,"");printf("%s",$0);}' | sed '1s/^/>/' | sed '${s/$/\n/}' > fasta_${file}
done < output_results/sample_list.txt

cat fasta_* > ${NAME}_binary_alignments.fasta

raxmlHPC -n ${NAME} -s ${NAME}_binary_alignments.fasta -m BINCAT -p 12345
mv *.${NAME} output_results/phylogenetic_analysis/
