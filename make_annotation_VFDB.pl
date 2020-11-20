#!/usr/bin/perl
open(INFO,"VFDB_setB_pro.info")||die $!;
open(ANNO,">VFDB_setB_pro.anno")||die $!;
print ANNO ("gene_ID\tgene_name\ttoxin_name\tGenus\tSpecies\tSub_Species_and_Strain\n");
while(<INFO>){
	$_=~s/\'/_/g;
	$_=~s/\#/_/g;
	$_=~s/\,/_/g;
	$_=~/\>(\S+)\s\((.+)\)\s(.+)\s\[.+\]\s\[(.+)\]\n/;
	my $gene_ID=$1;
	my $gene_name=$2;
	my $toxin_name=$3;
	my $organism=$4;
	my @microorganism=split(/\s/,$organism);
	my $Genus=$microorganism[0];
	my $Species=$microorganism[0]."_".$microorganism[1];
	my $Sub_Species_and_Strain="";	#define the variable outside the if(){} to avoid it becoming a local variable
	if(scalar(@microorganism)>2){
		$organism=~/\S+\s\S+\s(.+)/;
		$Sub_Species_and_Strain=$1;
		}
	else{$Sub_Species_and_Strain="NA"}
	print ANNO ("$gene_ID\t$gene_name\t$toxin_name\t$Genus\t$Species\t$Sub_Species_and_Strain\n");
	if(!($gene_ID && $gene_name && $toxin_name && $Genus && $Species && $Sub_Species_and_Strain)){
		print("$gene_ID\t$gene_name\t$toxin_name\t$Genus\t$Species\t$Sub_Species_and_Strain\n");
		}	#if the line contains empty element, print it to the screen
	}
	
close(INFO);
close(ANNO);
