#!/usr/bin/perl
#conpare the description of a query with the old annotation of each hit in IGC.fa
open(BLASTN,"$ARGV[0]")||die ("cannot open $ARGV[0]");
open(IGC,"/mnt/osf2/user/meity/database/IGC/1.GeneCatalogs/IGC.fa")||die ("cannot open IGC.fa");
open(OUT,">CompareNewAndOld.txt")||die ("cannot open CompareNewAndOld.txt");
%IGC_Anno=();
while(<IGC>){
	if($_=~/\>(\S+)/){
		$IGC_GeneName=$1;
		if($_=~/\>(.+)\n/){
			$IGC_old_anno=$1;
			$IGC_Anno{$IGC_GeneName}=$IGC_old_anno;
#			print("KEY\:$IGC_GeneName\nVALUE\:$IGC_Anno{$IGC_GeneName}\n");	#test
			}
		}
	}

while(<BLASTN>){	#1 blastn version
	if($_=~/processed/){last;}
#	print("1 $_");	#test
	$_=<BLASTN>;	#2 query information
#	print("2 $_");	#test
	$_=~/Query\:\s(.+)\n/;
	$query=$1;
	$_=<BLASTN>;	#3 database information
#	print("3 $_");	#test
	$_=<BLASTN>;	#4 Fields or "0 hits found"
	if($_=~/Fields/){
		print OUT ("$query\n");
#		print("4 $_");  #test
		$_=<BLASTN>;	#5 hits times
		$_=~/\#\s([0-9]*)\shits\sfound/;
		$hit=$1;
		$i=0;
#		print("5 $_");	#test
		while($i<$hit){
			$_=<BLASTN>;	#6 mached genes
#			print("6 $_");	#test
			@match=split(/\t/,$_);
			$IGC_GeneName=$match[1];
			$identity=$match[2];
			$e_vaule=$match[10];			
			$bit_score=$match[11];
			chomp($bit_score);      #remove the "\n" at the end
			print OUT ("$identity\t$e_vaule\t$bit_score\t$IGC_Anno{$IGC_GeneName}\n");
			$i++;
			}
		print OUT ("\n");
		}	
	}
close(BLASTN);
close(OUT);
close(IGC);
