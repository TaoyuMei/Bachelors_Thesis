#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=20G
#$ -q beta.q
#$ -pe smp 24
blastn -query VFDB_setB_nt.fas -db /mnt/osf2/user/meity/database/IGC/1.GeneCatalogs/IGC.fa -out blastnIGC.out -outfmt 7
