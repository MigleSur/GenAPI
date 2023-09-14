#!/bin/bash
NAME=$1
THREADS=$2
ALIGNMENT_COVERAGE=$3
IDENTITY=$4
geneCov1=$5
geneCov2=$6
geneIden1=$7
geneIden2=$8
geneLen=$9
input=${10}
output=${11}
echo "Analysis name: $NAME
Number of threads:$THREADS
Alignment coverage threshold for CD-HIT-EST: $ALIGNMENT_COVERAGE
Identity threshold for CD-HIT-EST: $IDENTITY
First minimum threshold for gene coverage: $geneCov1
Second minimum threshold for gene coverage: $geneCov2
First minimum threshold for gene identity: $geneIden1
Second minimum threshold for gene identity: $geneIden2
Minimum gene length used for analysis: $geneLen
Input folder: $input
Output folder: $output" > ${output}/${NAME}_settings
