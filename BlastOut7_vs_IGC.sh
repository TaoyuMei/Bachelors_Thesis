#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=20G
#$ -q beta.q
#$ -pe smp 24
perl BlastOut7_vs_IGC.pl blastnIGC.out 
