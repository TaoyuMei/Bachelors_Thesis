#!/usr/bin/perl
#convert the blastn output file in No.7 format to the MSV input file
open(BLASTN,"$ARGV[0]")||die ("cannot open $ARGV[0]");
open(OUT,">InPutForMSV.txt")||die ("cannot open InPutForMSV.txt");
print OUT ("ID\tToxin_name\tIGC_GeneName\tRaw_GeneName\tidentity\tRelated_Micro\tKO\n");
$ID=1;
while(<BLASTN>){	#1 blastn version
	if($_=~/processed/){last;}
#	print("1 $_");	#test
	$_=<BLASTN>;	#2 query information
#	print("2 $_");	#test
#	$query=$_;	#test
	$_=~/Query\:\s(\S+)\s\((\S+)\)(.+)\[(.+)\]\s\[(.+)\]\n/;
	$gene_number=$1;	#some of them do not have gi number
	$gene_name=$2;
	$gene_name=~s/\'//g;	#some gene name contain "'" which cannot be read by R read.table 
	$toxin=$3;
	$toxin=~s/\'//g;	 #some toxin name contain "'" which cannot be read by R read.table
	$_=~/\[(.+)\]\s\[(.+)\]\n/;	#in some cases, e.g. when $ID>2176 && $ID<2186, the two cannot be match and catch in above attempt
	$maybe_gene_family=$1;
	$organism=$2;	
	if($toxin eq ""){$_=~/Query\:\s\S+\s\S+\s(.+)\[.+\]\n/;$toxin=$1;}	#sometimes the toxin name cannot be catched
	if($toxin eq " - "){$toxin=$gene_name;}	#if the toxin do not have a name,use its gene name
	$_=<BLASTN>;	#3 database information
#	print("3 $_");	#test
	$_=<BLASTN>;	#4 Fields or "0 hits found"
	if($_=~/Fields/){
#		print("4 $_");  #test
		$_=<BLASTN>;	#5 hits times
		$_=~/\#\s([0-9]*)\shits\sfound/;
		$hit=$1;
#		print("5 $_");	#test
		$i=0;
		while($i<$hit){
			$_=<BLASTN>;	#6 mached genes
#			print("6 $_");	#test
			@match=split(/\t/,$_);
			$IGC_GeneName=$match[1];
			$identity=$match[2];
			$e_value=$match[10];
			$bit_score=$match[11];
			chomp($bit_score);      #remove the "\n" at the end
#			if($e_value<0.001 && $identity>97){
				print OUT ("$ID\t$toxin\t$IGC_GeneName\t$gene_name\t$identity\t$organism\t$gene_number\n");
#				if($ID>2176 && $ID<2186){print("1$ID\n2$toxin\n3$IGC_GeneName\n4$gene_name\n5$identity\n6$organism\n7$gene_number\n8$maybe_gene_family\n\n");}	#test
#				if($ID==1||$ID==807||$ID==808||$ID==809||$ID==51030){print("$query\n");}	#test
				$ID++;
				if(!($ID && $toxin && $IGC_GeneName && $gene_name && $identity && $organism && $gene_number)){
					print("$ID\t$toxin\t$IGC_GeneName\t$gene_name\t$identity\t$organism\t$gene_number\n");
					}	#to find and correct missing element
#				}	#filter by identity and e value
			$i++;
			}
		}	
	}
close(BLASTN);
close(OUT);
