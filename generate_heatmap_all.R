 #!/usr/bin/env Rscript

library(pheatmap)

args <- commandArgs()

# first argument is args[6] and so on

analysis_name<- args[6]

input<-paste("output_results/gene_presence_absence_",analysis_name,".txt", sep="")

gene_table <- read.table(file=input, h=T, row.names=1)

trans_gene_table <- t(gene_table)



file_name <- paste("output_results/heatmap_plot_all_genes_",analysis_name,".png", sep="")

h <- nrow(trans_gene_table) * 15 + max(nchar(colnames(trans_gene_table))) * 10 + 100

w <- ncol(trans_gene_table) * 1 + max(nchar(colnames(trans_gene_table))) * 10 + 300

png(file_name, height=h, width=w)
pheatmap(trans_gene_table, color = c("#FFC94E", "#A64EF2"), cluster_rows=T, cluster_cols = F, legend_breaks = c(T,F), legend_labels = c("Present", "Absent"), show_colnames = F, cellwidth = 1, cellheight=15)
dev.off()
