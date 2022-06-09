# GenAPI

GenAPI is a program for gene presence absence table generation for series of closely related bacterial genomes from annotated GFF files. For genome annotation [prokka](https://github.com/tseemann/prokka) software could be used.

### Purpose

Initially the program was written as an alternative for [Roary](http://sanger-pathogens.github.io/Roary/) for incomplete very closely related bacteria genomes. The tool was validated on multiple real and simulated datasets and it performed well by identifying all truly absent genes and calling very little false positives.

### Versions of software it was tested against

Before running the program make sure that the following programs are installed and added to the path: <br/>
[BLAST >=2.6.0+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download) <br/>
[CD-HIT >=4.6.1](http://weizhongli-lab.org/cd-hit/) <br/>
[Bedtools >=2.26](http://bedtools.readthedocs.io/en/latest/) <br/>
<br/>
Requirements for optional visualizations: <br/>
Heatmaps: <br/>
[R >=3.2.5](https://www.r-project.org/) <br/>
[pheatmap >=1.0.10](https://cran.r-project.org/web/packages/pheatmap/pheatmap.pdf) <br/>
Phylogenetic tree (minimum 4 samples are required for the tree to be created): <br/>
[RAxML >=8.2.11](https://sco.h-its.org/exelixis/web/software/raxml/index.html) <br/>

### Installation

Clone the repository:
```shell
git clone https://github.com/MigleSur/GenAPI.git
```

Add the following line to your .bashrc (if the GenAPI is located in a different directory than /bin/bash, use the path to that directory):
```shell
export PATH=$PATH:/usr/bin/GenAPI/bin
```

Reload the .bashrc file by running:
```shell
source ~/.bashrc
```

To run the program move to the folder where the input files are located and run:
```
genapi [options] [-n <analysis name>]
```

### Input

Annotated contig/scaffold/genome GFF files of the chosen samples have to be placed in the directory from which the program is being run. GenAPI uses unique IDs from the GFF file as annotations, so it would be easy to trace back the gene of interest. 

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
        -t, --tree      Create a phylogenetic tree using gene presence-absence
                        matrix. Requires RAxML to be installed.
                        Default: False
        -m, --matrix    Create a gene presence-absence matrix visualization. Requires
                        Rscript and pheatmap library to be installed.
                        Default: False
        
        -v, --version   Print the tool version.
        -h, --help      Print this message.
```
First minimum alignment length threshold and first minimum identity threshold are used as a pair. The same goes for the second pair. It is not advised to change those arguments unless there is a strong reason for doing that.

The minimum length requirement for the gene to be included in the gene presence-absence matrix is 150 bp, it can be changed but not recommended unless it was made sure that lower threshold is required.

### Disclaimer

GenAPI does not take into account gene duplicates, therefore if there are variable number of copies of the same gene in different samples, it will not be detected. For this kind of analysis the complete genome should be used with other tools developed for that purpose. GenAPI was developed to identify novel gene acquisition and complete gene deletion, therefore multiple gene copies were not included.

GenAPI does not take into account incomplete deletions in the genes. GenAPI was developed to identify gene deletions and acquisitions, not deletions and acquisitions within the genes. There are many excellent tools for deletion/acquisition within gene detection.

### Output

All the output files are placed in output_results directory inside the directory in which the program is being run. <br/>

Output file name | Description
------------ | -------------
clustered_genes_[name].ffn | Pan-genome nucleotide sequences file
gene_presence_absence_[name].txt | Tab seperated gene presence/absence table file
sample_gene_stats | Each sample's best blast alignment statistics for all the pan-genome genes
phylogenetic_analysis | Phylogenetic tree output from RAxML (optional)
heatmap_plot_all_genes_[name].png | Heatmap visualization for all the pan-genome genes (optional)
heatmap_plot_variable_genes_[name].png | Heatmap visualization for lost or acquired genes (optional)

### Citation

Gabrielaite, M., Marvig, R.L. GenAPI: a tool for gene absence-presence identification in fragmented bacterial genome sequences. BMC Bioinformatics 21, 320 (2020). https://doi.org/10.1186/s12859-020-03657-5

### Author

Migle Gabrielaite | migle.gabrielaite@regionh.dk

