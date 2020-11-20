#!/usr/bin/perl
open(INFO,"VFDB_setB_pro.info")||die $!;
open(ANNO,">VFDB_setB_pro.org.anno")||die $!;
#$print ANNO ("gene_ID\tgene_name\ttoxin_name\torganism\n");
while(<INFO>){
	$_=~s/\'/_/g;
	$_=~s/\#/_/g;
	$_=~s/\,/_/g;
	$_=~/\>(\S+)\s\((.+)\)\s(.+)\s\[.+\]\s\[(.+)\]\n/;
	my $gene_ID=$1;
	my $gene_name=$2;
	my $toxin_name=$3;
	my $organism=$4;
	print ANNO ("VFDB\t$gene_ID\t$gene_name\t$toxin_name\t$organism\n");
	if(!($gene_ID && $gene_name && $toxin_name && $organism)){
		print("$gene_ID\t$gene_name\t$toxin_name\t$organism\n");
		}	#if the line contains empty element, print it to the screen
	}
	
close(INFO);
close(ANNO);
