#!/usr/bin/perl
#convert the blastn output file in No.7 format to the MSV input file
if(!open(BLASTN,"$ARGV[0]")){die ("cannot open $ARGV[0]");}
if(!open(OUT,">InPutForMSV.txt")){die ("cannot open InPutForMSV.txt");}
print OUT ("ID\tToxin_name\tIGC_GeneName\tRaw_GeneName\tidentity\tRelated_Micro\tKO\n");
$ID=1;
while(<BLASTN>){	#1 blastn version
	if($_=~/processed/){last;}
#	print("1 $_");	#test
	$_=<BLASTN>;	#2 query information
#	print("2 $_");	#test
	$_=~/Query\:\s\w+\:\w+\|(K.+)\|[0-9].+\s(.+)\|.+\|(.+)\|(.+)\n/;
	$KO=$1;
	$enzyme=$2;	#some gene doesn't have gene name, but all have enzyme name
	$toxin=$3;
	$organism=$4;
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
			print OUT ("$ID\t$toxin\t$IGC_GeneName\t$enzyme\t$identity\t$organism\t$KO\n");
			$ID++;
			$i++;
			}
		}	
	}
close(BLASTN);
close(OUT);
