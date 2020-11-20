#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=10G
#$ -q beta.q
#$ -pe smp 4

tblastn -query Human_pathogenic_bacterial_exotoxin -db /mnt/osf2/user/meity/database/IGC_250Twins/1.GeneCatalogs/250twins.fa -out DBETH_229_IGC_Blastn7_97.out -outfmt 7 -num_threads 10
