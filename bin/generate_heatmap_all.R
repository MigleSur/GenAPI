#!/usr/bin/env Rscript

library(pheatmap)

args <- commandArgs()

# first argument is args[6] and so on

analysis_name<- args[6]

print(analysis_name)

input<-paste("output_results/gene_presence_absence_",analysis_name,".txt", sep="")

gene_table <- read.table(file=input, h=T, row.names=1)

# all gene table
trans_gene_table <- t(gene_table)

# lost/acquired gene table
variable_gene_table <- gene_table[rowSums(gene_table)!=ncol(gene_table),]
trans_variable_gene_table <- t(variable_gene_table)

file_name_all <- paste("output_results/heatmap_plot_all_genes_",analysis_name,".png", sep="")

file_name_variable <- paste("output_results/heatmap_plot_variable_genes_",analysis_name,".png", sep="")


h_all <- nrow(trans_gene_table) * 15 + max(nchar(colnames(trans_gene_table))) * 10 + 100

w_all <- ncol(trans_gene_table) * 1 + max(nchar(colnames(trans_gene_table))) * 10 + 300

h_variable <- nrow(trans_variable_gene_table) * 15 + max(nchar(colnames(trans_gene_table))) * 10 + 100

w_variable <- ncol(trans_variable_gene_table) * 10 + max(nchar(rownames(trans_gene_table))) * 10 + 100

png(file_name_all, height=h_all, width=w_all)
pheatmap(trans_gene_table, color = c("#FFC94E", "#A64EF2"), cluster_rows=T, cluster_cols = F, legend_breaks = c(T,F), legend_labels = c("Present", "Absent"), show_colnames = F, cellwidth = 1, cellheight=15)
dev.off()

png(file_name_variable, height=h_variable, width=w_variable)
pheatmap(trans_variable_gene_table, color = c("#FFC94E", "#A64EF2"), cluster_rows=F, cluster_cols = F, legend_breaks = c(T,F), legend_labels = c("Present", "Absent"), show_colnames = T, cellwidth = 10, cellheight=15)
dev.off()
