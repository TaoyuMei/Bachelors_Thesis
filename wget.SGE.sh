#!/bin/bash
#$ -cwd
#$ -N EC2fa
#$ -q beta.q
#$ -pe smp 4
#$ -l h_vmem=8G
#$ -V
wget www.baidu.com
