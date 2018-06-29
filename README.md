# GenAPI

GenAPI is a program for gene presence absence table generation for series of closely related bacterial genomes from annotated FASTA file. For genome annotation [prokka](https://github.com/tseemann/prokka) could be used.

### Purpose

Initially the program was written as an alternative for [Roary](http://sanger-pathogens.github.io/Roary/). It was used for the analysis of the bacterial isolates from the same source taken over time, thus the isolates were very closely related. The program performed well even with minor differences between samples and managed to identify them. 

### Versions of software it was tested against

Before running the program make sure that the following programs are installed and added to the path: <br/>
[BLAST >=2.6.0+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download) <br/>
[CD-HIT >=4.6.1](http://weizhongli-lab.org/cd-hit/) <br/>
[Bedtools >=2.26](http://bedtools.readthedocs.io/en/latest/) <br/>

### Installation

Clone the repository:
```shell
git clone https://github.com/MigleSur/GenAPI.git
```

Add the following line to your .bashrc (if the GenAPI is located in a different directory than /bin/bash, use the path to that directory):
```shell
export PATH=$PATH:/usr/bin/GenAPI
```

Reload the .bashrc file by running:
```shell
source ~/.bashrc
```

To run the program move to the folder where the output files should be produced and run:
```
genapi [options] [-n <analysis name>]
```

### Input

Annotated contig/scaffold GFF files of the chosen samples have to be placed in the directory from which the program is being run. 

### Usage

```
Usage: genapi [options] [--name <analysis name>]

        -n, --name      Chosen analysis name.
                        Default: date in yyyy-mm-dd format
        -p, --threads   Number of threads used for running the analysis.
                        Default: 1
        -a, --coverage  Alignment coverage for the shorter sequence for CD-HIT-EST.
                        Default: 0.8
        -c, --identity  Sequence identity threshold for CD-HIT-EST.
                        Default: 0.9
        -x, --geneCov1  First minimum alignment length threshold.
                        Default: 0.25
        -y, --geneCov2  Second minimum alignment length threshold.
                        Default: 0.50
        -w, --geneIden1 First minimum gene identity threshold.
                        Default: 0.98
        -z, --geneIden2 Second minimum gene identity threshold.
                        Default: 0.90
        -l, --geneLen   Minimum gene length. Shorter than the threshold genes are
                        excluded from the analysis.
                        Default: 150
        -v, --version   Print the tool version.
        -h, --help      Print this message.
```
First minimum alignment length threshold and minimum identity threshold are used as a pair. The same goes for the second pair. It is not advised to change those arguments unless there is a strong reason for doing that.

### Output

All the output files are placed in output_results directory inside the directory in which the program is being run. <br/>

Output file name | Description
------------ | -------------
clustered_genes_[name].ffn | Pan-genome nucleotide sequences file
gene_presence_absence_[name].txt | Tab seperated gene presence/absence table file
sample_gene_stats | Each sample's best blast alignment statistics for all the pan-genome genes

### Author

Migle Gabrielaite | migle.gabrielaite@gmail.com

