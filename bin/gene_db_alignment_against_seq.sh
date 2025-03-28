#!/bin/bash

NAME=$1
geneCov1=$2
geneCov2=$3
geneIden1=$4
geneIden2=$5
threads=$6
evalue=0.01

LANG=C grep ">" output_results/clustered_genes_${NAME}.ffn | awk '{print substr($0, 2,1000)}'> tmp_genelist

cat output_results/clustered_genes_${NAME}.ffn | awk '$0 ~ ">" {print c; c=0; printf substr($0,2,1000) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; } ' | sed '/^\s*$/d'  > tmp_genelength

mkdir -p output_results/sample_gene_stats

mkdir -p output_results/sample_blast_results

while read lines
do

	makeblastdb -in ${lines}.fasta -input_type fasta -dbtype nucl
	
	blastn -task blastn -num_threads $threads -evalue $evalue -query output_results/clustered_genes_${NAME}.ffn -db ${lines}.fasta -outfmt 6 > ${lines}_outblast

	rm -f output_results/sample_gene_stats/"$lines"_db_gene_presence.txt


	while read  gene 
	do		

		GEN=`echo ${gene}`
		LENGTH=`LANG=C grep -wF "${GEN}" tmp_genelength`
		LEN=`awk '{print $2}' <<< ${LENGTH}`

		LANG=C grep -wF "$GEN" ${lines}_outblast > tmp_all_headline
		
		LC_ALL=C sort -gr -k11,11 -k12,12n tmp_all_headline | tail -2 > tmp_headline
		
		alignmentlen_first=`awk '{print $4}' tmp_headline | tail -1`	
		alignmentlen_second=`awk '{print $4}' tmp_headline | head -1`
		alignment_first=`cat tmp_headline | tail -1`		
		alignment_second=`cat tmp_headline | head -1`

		# if one of the alignments have the same e-value as the best one and is at least cov1 (25%) of the gene length and iden1 (98%) of identity or is  cov2 (50%) of the gene length and iden2 (90%) of identity
	
		
		first_alignment_evalue=`awk '{print $11}'<<< ${alignment_first}`
		best_alignments1=`awk -v var1=$first_alignment_evalue -v var2=$LEN -v cov1=$geneCov1 -v iden1=$geneIden1 '$11==var1 && $3>=iden1 && $4>=var2*cov1' tmp_all_headline `
		best_alignments2=`awk -v var1=$first_alignment_evalue -v var2=$LEN -v cov2=$geneCov2 -v iden2=$geneIden2 '$11==var1 && $3>=iden2 && $4>=var2*cov2' tmp_all_headline `
		
		# if the first alignment does not exist
		if [[ -z $alignment_first ]]
                then
                        ALIGN=0
                        PERCENT=0
                        FRACTION=0
			AAA=0
                # if there is only one alignment
                elif [[ "$alignment_first" == "$alignment_second" ]]		
		then
			ALIGN=`awk '{print $4}' <<< "${alignment_first}"`
			PERCENT=`awk '{print $3}' <<< "${alignment_first}"`
			FRACTION=`awk -v var1=$LEN '{print $4/var1}' <<< "${alignment_first}"`
			AAA=0
		# checking if at least one of the alignments with the lowest e-value have iden1 (>=98%) identity and cov1 (>=25%) coverage
		elif [[ -n $best_alignments1 ]]
		then
			ALIGN=0
			PERCENT=0
			FRACTION=0
			while read element
			do
				ALIGN_temp=`awk '{print $4}' <<< "${element}"`
				PERCENT_temp=`awk '{print $3}' <<< "${element}"`
				FRACTION_temp=`awk -v var1=$LEN '{print $4/var1}' <<< "${element}"`
				if (( $(echo "${ALIGN_temp}> ${ALIGN}" | bc ) )) && (( $(echo "${PERCENT_temp}>${PERCENT}" | bc -l) )) && (( $(echo "${FRACTION_temp}>${FRACTION}" | bc -l) ))
				then
					ALIGN=${ALIGN_temp}
					PERCENT=${PERCENT_temp}
					FRACTION=${FRACTION_temp}
				fi		
			done <<< "$best_alignments1"
			AAA="1"
		# checking if at least one of the alignments with the lowest e-value have iden2 (>=90%) identity and cov2 (>=50%) coverage
		elif [[ -n $best_alignments2 ]]
		then
			ALIGN=0
                        PERCENT=0
                        FRACTION=0
                        while read element
                        do
                                ALIGN_temp=`awk '{print $4}' <<< "${element}"`
                                PERCENT_temp=`awk '{print $3}' <<< "${element}"`
                                FRACTION_temp=`awk -v var1=$LEN '{print $4/var1}' <<< "${element}"`
                                if (( $(echo "${ALIGN_temp}> ${ALIGN}" | bc ) )) && (( $(echo "${PERCENT_temp}>${PERCENT}" | bc -l) )) && (( $(echo "${FRACTION_temp}>${FRACTION}" | bc -l) ))
                                then
                                        ALIGN=${ALIGN_temp}
                                        PERCENT=${PERCENT_temp}
                                        FRACTION=${FRACTION_temp}
                                fi
                        done <<< "$best_alignments2"
                        AAA="2"
		else
		
			# sorting makes the first interval start at lower number than the second one
                	cat tmp_headline | sort -k7,7n > tmp_headline_sorted
                	first_aln=`head -1 tmp_headline_sorted`
                	second_aln=`tail -1 tmp_headline_sorted`

                	# interval 1
                	first_interval_e=`awk '{print $8}' <<< ${first_aln}`
                	first_interval_s=`awk '{print $7}' <<< ${first_aln}`

                	# interval 2
                	second_interval_e=`awk '{print $8}' <<< ${second_aln}`
                	second_interval_s=`awk '{print $7}' <<< ${second_aln}`

                	x=`echo "$LEN/2" | bc -l`

                	# find max interval end and min interval start
                	max_end=$(echo $((${second_interval_e}>${first_interval_e}?${second_interval_e}:${first_interval_e})))
                	min_start=$(echo $((${second_interval_s}<${first_interval_s}?${second_interval_s}:${first_interval_s})))

                	overlap_interval=`echo "$max_end-$min_start+1" | bc`
                	nonoverlap_interval=`echo "($alignmentlen_first+$alignmentlen_second)" | bc`	
			
			# first 2 best alignments get merged
			first_align=`awk '{print $4}' <<< ${first_aln}`
			second_align=`awk '{print $4}' <<< ${second_aln}`
	
			first_percent=`awk '{print $3}' <<< ${first_aln}`
			second_percent=`awk '{print $3}' <<< ${second_aln}`

			# if the first alignment overlaps with the second alignment and first alignment is not longer than the second alignment
			if (( $(echo "$first_interval_e>=$second_interval_s" | bc -l) )) && (( $(echo "$first_interval_e<=$second_interval_e" | bc -l) ))
			then
				ALIGN=`echo "scale=2;${second_interval_e}-${first_interval_s}+1" | bc`
				if (( $(echo "$first_percent>=$second_percent" | bc -l) ))
				then
					PERCENT=`echo "scale=3; (($second_interval_s-$first_interval_s+1)*$first_percent + ($second_interval_e-$first_interval_e)*$second_percent + $first_percent*($first_interval_e-$second_interval_s))/($ALIGN)" | bc`
				else	
					PERCENT=`echo "scale=3; (($second_interval_s-$first_interval_s+1)*$first_percent + ($second_interval_e-$first_interval_e)*$second_percent + $second_percent*($first_interval_e-$second_interval_s))/($ALIGN)" | bc`
				fi
				FRACTION=`echo "scale=5; $ALIGN/$LEN" | bc | awk '{printf "%.2f\n", $0}'`
			AAA="3"
			# if the intervals do not overlap
			elif (( $(echo "$first_interval_e<=second_interval_s" | bc -l ) ))
			then
				ALIGN=`echo "$first_align+$second_align" | bc`
				PERCENT=`echo "scale=3; (($first_percent*$first_align)+($second_percent*$second_align))/(($second_align+$first_align))" | bc`
				FRACTION=`echo "scale=5; $ALIGN/$LEN" | bc | awk '{printf "%.2f\n", $0}'`
				AAA="4"
			# if the second interval is within the first interval, only the first interval is considered
			else	
				ALIGN=`awk '{print $4}' <<< ${alignment_first}`
				PERCENT=`awk '{print $3}' <<< ${alignment_first}`
				FRACTION=`awk -v var1=$LEN '{print $4/var1}' <<< ${alignment_first}`
				AAA="5"
			fi
		fi

		# define the variable gene
		if (( $(echo "scale=4;$FRACTION>=$geneCov1" | bc) )) && (( $(echo "scale=4;$PERCENT>=$geneIden1" | bc) )) ||  (( $(echo "scale=4;$FRACTION>=$geneCov2" | bc) )) && (( $(echo "scale=4;$PERCENT>=$geneIden2" | bc) )) 
		then
			VARGENE=0
		else
			VARGENE=1
		fi
		
		echo "$lines     $gene   $LEN   $ALIGN  $FRACTION       $PERCENT	$VARGENE	$AAA" >> output_results/sample_gene_stats/"$lines"_db_gene_presence.txt

		rm -f tmp_headline
		rm -f tmp_headline_sorted

	done < tmp_genelist

	mv ${lines}_outblast output_results/sample_blast_results

done < output_results/sample_list.txt

rm -f tmp_all_headline
rm -f tmp_genelist
rm -f tmp_genelength
rm -f *.nin
rm -f *.nhr
rm -f *.nsq
