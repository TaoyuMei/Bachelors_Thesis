#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=16G
#$ -q meta.q
#$ -pe smp 12
perl VFDB_BLAST_to_MSV.pl VFDB_BlastnIGC7.out