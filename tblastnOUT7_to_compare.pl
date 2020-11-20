#!/usr/bin/perl
#convert the tblastn output file in No.7 format to comparing file
open(TBLASTN,"DBETH_VFDB_UniProt_IGC_tblastn7.out")||die $!;
open(CLSTR,"DBETH_VFDB_UniProt_non-redundant.fasta.clstr")||die $!;
open(ANNO,"merge_org.anno")||die $!;
open(OUT,">merge_compare_antibio")||die $!;

my %q_length=();
my %clstr=();
my $key="";
while(<CLSTR>){
	if($_=~/\.\.\.\s\*/){
		$_=~/\>(\S+)\.\.\.\s\*/;
		$key=$1;
		$clstr{$key}=$1;
		$_=~/\s([0-9]+)aa\,\s\>/;       #
		$q_length{$key}=$1;     #
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

#print OUT ("ID\tToxin_name\tIGC_GeneName\tRaw_GeneName\tidentity\tRelated_Micro\tKO\n");
#my $ID=1;
my %all_IGC=();
while(<TBLASTN>){	#1 blastn version
	if($_=~/processed/){last;}
#	print("1 $_");	#test
	$_=<TBLASTN>;	#2 query information
#	print("2 $_");	#test
	$_=<TBLASTN>;	#3 database information
#	print("3 $_");	#test
	$_=<TBLASTN>;	#4 Fields or "0 hits found"
	if($_=~/Fields/){
#		print("4 $_");  #test
		$_=<TBLASTN>;	#5 hits times
		$_=~/\#\s([0-9]*)\shits\sfound/;
		$hit=$1;
#		print("5 $_");	#test
		$i=0;
		while($i<$hit){
			$_=<TBLASTN>;	#6 mached genes
#			print("6 $_");	#test
			my @match=split(/\t/,$_);
			my $Raw_GeneName=$match[0];
			my $IGC_GeneName=$match[1];
			my $identity=$match[2];
			my $alignment_length=$match[3];
			my $query_length=$match[7]-$match[6];
			if($query_length<0){$query_length=$query_length/(-1);}
			$query_length+=1;
			my $coverage=$query_length/$q_length{$Raw_GeneName};
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
#				print OUT ("$ID\t$toxin\t$IGC_GeneName\t$KEGG_GeneName\t$identity\t$organism\t$KO\n");
#				$ID++;
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

close(TBLASTN);
close(OUT);
close(CLSTR);
close(ANNO);

