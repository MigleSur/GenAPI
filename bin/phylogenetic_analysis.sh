#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAME=$1
output=$2
input=$3
threads= $4
mkdir -p ${output}/output_results/phylogenetic_analysis
rm -f ${output}/output_results/phylogenetic_analysis/*.${NAME}

while read file
echo ${file} 
do
	cat ${input}/tmp_column_${file}.txt | awk 'NR==1{print}NR>1{sub(/\n/,"");printf("%s",$0);}' | sed '1s/^/>/' | sed '${s/$/\n/}' > ${input}/fasta_${file}
done < ${output}/output_results/sample_list.txt

cat ${input}/fasta_* > ${input}/${NAME}_binary_alignments.fasta

raxmlHPC -n ${output}/${NAME} -s ${input}/${NAME}_binary_alignments.fasta -m BINCAT -p 12345 -T ${threads}

if [ `ls -1 ${input}/*.${NAME} 2>/dev/null | wc -l ` -gt 0  ]
then
	mv *.${NAME} ${output}/output_results/phylogenetic_analysis/ 
else
	rm -rf ${output}/output_results/phylogenetic_analysis
	bash ${SCRIPT_DIR}/remove_temp.sh	
fi

