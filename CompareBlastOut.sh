#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=16G
#$ -q meta.q
#$ -pe smp 12
for i in $(seq 0 12)
do
	blastn -query toxin_genes_for_blast.fasta -db /home/meity/self_downloaded_DB/IGC_fa/IGC.fa.blastdb -out Blastn$i -outfmt $i;
done
