#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=20G
#$ -q beta.q
#$ -pe smp 24
perl BlastOut7_to_MSVin.pl blastnIGC.out 