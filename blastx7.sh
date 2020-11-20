#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=20G
#$ -q meta.q
#$ -pe smp 24
date &&
blastx -query ./IGC_250Twins/250twins.fa -db ./non_redundant_combined/DBETH_VFDB_UniProt_non-redundant.fasta -out IGC_DBETH_VFDB_UniProt_non-redundant_blastx7.out -query_gencode 11 -outfmt 7 -num_threads 15 &&
date
