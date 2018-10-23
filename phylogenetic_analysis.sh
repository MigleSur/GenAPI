#!/bin/bash

mkdir -p phylogenetic_analysis
rm -f phylogenetic_analysis/*.${NAME}

raxmlHPC -n ${NAME} -s ${NAME}_binary_alignments.fasta -m BINCAT -p 12345 -w phylogenetic_analysis
