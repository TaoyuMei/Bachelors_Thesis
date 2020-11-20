#!/usr/bin/perl
open(COMP,"merge_compare_antibio")||die $!;
open(MSVIN,">MSVin.txt")||die $!;
print MSVIN ("Num\tToxin_name\tIGC_GeneName\tRaw_GeneName\n");

my $Num=1;
my $IGC_GeneName="";
my $Toxin="";
my $RawGene="";

while(<COMP>){
	if($_=~/\>/){

		if(($Toxin ne "") && ($RawGene ne "")){
			if($Toxin=~/\//){
				@ToxArray=split(/\//,$Toxin);
				foreach my $tox (@ToxArray){
					if($tox ne "hypothetical protein"){$Toxin=$tox;last;}
					}
				}
			print MSVIN ("$Num\t$Toxin\t$IGC_GeneName\t$RawGene\n");
			$Num++;
			}

		$_=~/\>(\S+)\n/;
		$IGC_GeneName=$1;
		$Toxin="";
		$RawGene="";
		}
	elsif(!($_=~/\-\-\-\-\-\-\-\-\-\-\-\-\-/)){
		if($_ eq "\n"){next;}
		my @Raw=split(/\t/,$_);
		my $Raw_GeneName=$Raw[4];	# LGR recommand db ID rather than NCBI gene name		
#		my $Raw_GeneName=$Raw[5];	#big molecule db is different, used for annotation table
#		print("$Raw_GeneName\n");	#test
##		$Raw_GeneName=~s/\(//g;
##		$Raw_GeneName=~s/\)//g;
#		print("$Raw_GeneName\n");	#test

                my $Toxin_name=$Raw[6]; #big molecule db is different
		$Toxin_name=~s/\)//g;
		$Toxin_name=~s/\(//g;

#		if($Raw_GeneName=~/\//){	#for annotation table
#			my @RawGeneArray=split(/\//,$Raw_GeneName);
#			foreach my $name (@RawGeneArray){
#				if(!($RawGene=~/$name/)){$RawGene.="\/".$name;}
#				}
#			}
#		elsif(!($RawGene=~/$Raw_GeneName/)){$RawGene.="\/".$Raw_GeneName;}

		if(!($Toxin=~/$Toxin_name/)){$Toxin.="\/".$Toxin_name;}
#		$RawGene=~s/^\///;
		$Toxin=~s/^\///;
		$RawGene=$Raw_GeneName;
		}
	}

if($Toxin=~/\//){
	@ToxArray=split(/\//,$Toxin);
	foreach my $tox (@ToxArray){
		if($tox ne "hypothetical protein"){$Toxin=$tox;last;}
		}
	}                                              
print MSVIN ("$Num\t$Toxin\t$IGC_GeneName\t$RawGene\n");

close(COMP);
close(MSVIN);
