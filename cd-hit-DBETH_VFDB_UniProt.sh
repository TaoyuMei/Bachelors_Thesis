#!/bin/bash
#$ -cwd
#$ -q beta.q
#$ -pe smp 24
#$ -l h_vmem=20G
#$ -V
cd-hit -i DBETH_VFDB_UniProt.fasta -o DBETH_VFDB_UniProt_non-redundant.fasta -c 1.00 -n 5 -M 20000 -d 0 
