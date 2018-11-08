#!/bin/bash

NAME=$1

rm -f tmp_genelist
rm -f tmp_column_*.txt
rm -f fasta_*
rm -f output_results/sample_list.txt
rm -f clustered_noshort_${NAME}
rm -f temp_variable_genes
#rm -rf output_results/sample_blast_results
rm -f *.fasta
rm -f *.fasta.fai
rm -f *.ffn
rm -f *_binary_alignments.fasta.reduced 
