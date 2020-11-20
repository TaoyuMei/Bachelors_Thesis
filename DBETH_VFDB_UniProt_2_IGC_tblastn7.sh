#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=20G
#$ -q beta.q
#$ -pe smp 24
date &&
tblastn -query DBETH_VFDB_UniProt_non-redundant.fasta -db /mnt/osf2/user/meity/database/IGC_250Twins/1.GeneCatalogs/250twins.fa -out DBETH_VFDB_UniProt_IGC_tblastn7.out -outfmt 7 -num_threads 15 &&
date
