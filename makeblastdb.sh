#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=20G
#$ -q beta.q
#$ -pe smp 24
#makeblastdb -dbtype prot -in /mnt/osf2/user/meity/database/DBETH/Human_pathogenic_bacterial_exotoxin -input_type fasta &&
#makeblastdb -dbtype prot -in /mnt/osf2/user/meity/database/VFDB_20180625_AA/VFDB_setB_pro.fas -input_type fasta &&
makeblastdb -dbtype prot -in /mnt/osf2/user/meity/database/BTXpred/toxin.fasta -input_type fasta
#makeblastdb -dbtype prot -in /mnt/osf2/user/meity/database/UniProt/uniprot_B.A.F_toxin.fasta -input_type fasta
