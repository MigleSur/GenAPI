#!/bin/bash

NAME=$1
input=$2
rm -f ${input}/tmp_genelist
rm -f ${input}/tmp_column_*.txt
rm -f ${input}/fasta_*
rm -f ${input}/output_results/sample_list.txt
rm -f ${input}/clustered_noshort_${NAME}
rm -f ${input}/temp_variable_genes
#rm -rf output_results/sample_blast_results
rm -f ${input}/*.fasta
rm -f ${input}/*.fasta.fai
rm -f ${input}/*.ffn
rm -f ${input}/*_binary_alignments.fasta.reduced 
