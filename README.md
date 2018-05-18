# GenMat

GenMat is a program for gene presence absence table generation for series of closely related bacterial genomes from annotated FASTA file. For genome annotation [prokka](https://github.com/tseemann/prokka) could be used.

### Purpose

Initially the program was written as an alternative for [Roary](http://sanger-pathogens.github.io/Roary/). It was used for the analysis of the bacterial isolates from the same source taken over time, thus the isolates were very closely related. The program performed well even with minor differences between samples and managed to identify them. 

### Versions of software it was tested against

Before running the program make sure that the following programs are installed and added to the path: <br/>
[BLAST 2.6.0+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download) <br/>
[CD-HIT 4.6.8](http://weizhongli-lab.org/cd-hit/) <br/>

### Installation

Clone the repository:
```shell
git clone https://github.com/MigleSur/GenMat.git
```

Add the following line to your .bashrc (if the GenMat is located in a different directory than /bin/bash, use the path to that directory):
```shell
export PATH=$PATH:/usr/bin/GenMat
```

Reload the .bashrc file by running:
```shell
source ~/.bash
```

To run the program move to the folder where the output files should be produced and run:
```
GenMat [chosen name for the analysis]
```

### Input

FASTA contig/scaffold files and annotated nucleotide FASTA files (.fna) of the files of interest have to be placed in the directory from which the program is being run. 

### Output

All the output files are placed in output_results directory inside the directory in which the program is being run. <br/>

Output file name | Description
------------ | -------------
clustered_genes_[name].ffn | Pan-genome nucleotide sequences file
gene_presence_absence_[name].txt | Tab seperated gene presence/absence table file
sample_gene_status | Each sample's best blast alignment statistics for all the pan-genome genes

### Author

Migle Gabrielaite | survilaite.migle@gmail.com

