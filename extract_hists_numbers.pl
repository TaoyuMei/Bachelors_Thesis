#!/usr/bin/perl
open(HITS,"$ARGV[0]")||die ("cannot open $ARGV[0]");
open(OUT,">hits_number_for_R.txt")||die ("cannot open hits_number_for_R.txt");
print OUT ("hits_number\ttimes\n");	#column names
%HitsCount=();	#define an empty hash array
#$QueryCount=0;	#test
while(<HITS>){
	if($_=~/#\s([0-9]*)\shits\sfound/){
#		$QueryCount++;	#test
		if($HitsCount{$1}>0){$HitsCount{$1}++;}else{$HitsCount{$1}=1;}
		}
	}
foreach $hits (sort{$a<=>$b}(keys(%HitsCount))){
	print OUT ("$hits\t$HitsCount{$hits}\n");
	}	#hits number is key, hash value is how many times does this hitsnumber appear
#print OUT ("total\t$QueryCount");	#test
close(HITS);
close(OUT);
