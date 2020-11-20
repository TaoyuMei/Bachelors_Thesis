#!/usr/bin/perl
#convert the blastx output file in No.7 format to comparing file
open(BLASTX,"IGC_DBETH_VFDB_UniProt_non-redundant_blastx7.out")||die $!;
open(CLSTR,"DBETH_VFDB_UniProt_non-redundant.fasta.clstr")||die $!;
open(ANNO,"merge_org.anno")||die $!;
open(OUT,">merge_compare_antibio")||die $!;

my %h_length=();
my %clstr=();
my $key="";
while(<CLSTR>){
	if($_=~/\.\.\.\s\*/){
		$_=~/\>(\S+)\.\.\.\s\*/;
		$key=$1;
		$clstr{$key}=$1;
		$_=~/\s([0-9]+)aa\,\s\>/;       #
		$h_length{$key}=$1;     #
		}
	elsif($_=~/\.\.\.\sat\s/){
		$_=~/\>(\S+)\.\.\.\sat\s/;
		$clstr{$key}=$clstr{$key}."\t".$1;
		}
	}

my %merge_anno=();
while(<ANNO>){
	my @anno=split(/\t/,$_);
	$merge_anno{$anno[1]}=$_;
	chomp($merge_anno{$anno[1]});
	}

my %all_IGC=();
while(<BLASTX>){	#1 blast+ version
	if($_=~/processed/){last;}
#	print("1 $_");	#test
	$_=<BLASTX>;	#2 query information
#	print("2 $_");	#test
	$_=<BLASTX>;	#3 database information
#	print("3 $_");	#test
	$_=<BLASTX>;	#4 Fields or "0 hits found"
	if($_=~/Fields/){
#		print("4 $_");  #test
		$_=<BLASTX>;	#5 hits times
		$_=~/\#\s([0-9]*)\shits\sfound/;
		$hit=$1;
#		print("5 $_");	#test
		$i=0;
		while($i<$hit){
			$_=<BLASTX>;	#6 mached genes
#			print("6 $_");	#test
			my @match=split(/\t/,$_);
			my $Raw_GeneName=$match[1];
			my $IGC_GeneName=$match[0];
			my $identity=$match[2];
			my $alignment_length=$match[3];	#include gaps
			my $hit_length=$match[9]-$match[8];
			if($hit_length<0){$hit_length=$hit_length/(-1);}
			$hit_length+=1;
			my $coverage=$hit_length/$h_length{$Raw_GeneName};
			my $e_value=$match[10];
			my $bit_score=$match[11];
			chomp($bit_score);      #remove the "\n" at the end
			
			if($identity>=80 && $e_value<=1e-10 && $coverage>=0.7){
				my $all_Raw="";
				@GeneID=split(/\t/,$clstr{$Raw_GeneName});
				foreach $GI (@GeneID){
					$all_Raw.="$identity"."\t"."$coverage"."\t"."$e_value"."\t"."$merge_anno{$GI}"."\n";
					}
				$all_Raw.="\-\-\-\-\-\-\-\-\-\-\-\-\-\n";
				if(!$all_IGC{$IGC_GeneName}){$all_IGC{$IGC_GeneName}=$all_Raw;}
				else{$all_IGC{$IGC_GeneName}.=$all_Raw;}
				}

			$i++;
			}
		}	
	}

foreach $IGC_GeneName_ (keys(%all_IGC)){
	print OUT ("\>$IGC_GeneName_\n$all_IGC{$IGC_GeneName_}\n");
	}

close(BLASTX);
close(OUT);
close(CLSTR);
close(ANNO);

