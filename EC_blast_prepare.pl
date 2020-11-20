#!/usr/bin/perl
#perl EC_blast_prepare.pl [a file containing EC number and toxins information] [a file containing microorganisms names and abbreviations] 
#download HTML files containing enzyme information including genes' names and sequences links

use LWP::Simple; 

$EC_xls=@ARGV[0];	
$abbre_name_micro=@ARGV[1];	

if(!open(INFO,"$EC_xls")){die ("cannot open $EC_xls");}	
if(!open(DNAOUT,">toxin_genes_for_blast.fasta")){die ("cannot open toxin_enzyme_genes_for_blast.fasta");}
if(!open(AAOUT,">toxin_proteins_for_blast.fasta")){die ("cannot open toxin_enzyme_proteins_for_blast.fasta");}	
	
while(<INFO>){	
	
#	print("$_\n");	#test
	$_=~/(.*)\t.*\t.*\t(.*)\t.*\t.*\n/;	#read toxin name and EC number, store in $1 and $2 respectively	
	$toxin_name=$1;
	$EC_number=$2;
	$url="http://www.kegg.jp/dbget-bin/www_bget?ec:".$EC_number;	 
	$EC_html=get($url);	#download the HTML file
	if(!open(HTML,">$EC_number")){die ("cannot open $EC_number");}	
	print HTML ("$EC_html");	
	close(HTML);	

	if(!open(EC,"$EC_number")){die ("cannot open $EC_number");}
	while(<EC>){	#
		if($_=~/\<nobr\>Genes\<\/nobr\>/){
#			print("$_");	#
			last;}
		}
	$Genes=<EC>;	#all gene information is included in one line in the html file
#<a href="/dbget-bin/www_bget?ecy:ECSE_0185">ECSE_0185</a>	

#	print("$Genes\n");	#test

	@organism_gene=$Genes=~m/\<a\shref\=\"\/dbget\-bin\/www_bget\?[a-z][a-z][a-z]*\:\w+\"\>\w+\<\/a\>/g;

	foreach $href (@organism_gene){	#
#		print("$href\n");	#test
		$href=~/\<a\shref\=\"\/dbget\-bin\/www_bget\?([a-z][a-z][a-z]*\:\w+)\"\>\w+\<\/a\>/;	
		$gene_number=$1;
		$href=~/\<a\shref\=\"\/dbget\-bin\/www_bget\?([a-z][a-z][a-z]*)\:\w+\"\>\w+\<\/a\>/;	#
		$organism=$1;
#		print("$gene_number\n");	#test
#		print("$organism\n");	#test
		if(!open(NAME,"$abbre_name_micro")){die ("cannot open $abbre_name_micro");}
		while(<NAME>){	#
			if($_=~/^E\s\s\s\s\s\s\s\s([a-z][a-z][a-z]*)\s\s(.+)/){	#
				if($1 eq $organism){$organism=$2;}	#
				}
			elsif($_=~/^D\s\s\s\s\s\s([a-z][a-z][a-z]*)\s\s(.+)/){	#
				if($1 eq $organism){$organism=$2;}
				} 
			}
		if(length($organism)>4){	#
#http://www.kegg.jp/dbget-bin/www_bget?-f+-n+n+eco:b0186  DNA sequence
#http://www.kegg.jp/dbget-bin/www_bget?-f+-n+a+eco:b0186  AA sequence

#			print("$organism\n");	#test
			
			$dna_url="http://www.kegg.jp/dbget-bin/www_bget?-f+-n+n+".$gene_number;	#
			$dna_txt=get($dna_url);
			$aa_url="http://www.kegg.jp/dbget-bin/www_bget?-f+-n+a+".$gene_number;
			$aa_txt=get($aa_url);	
			$gene_number=~/(\w*):(\w*)/;	#
			$gene_number=$1.".".$2;
			
			if(!open(GENE,">$gene_number")){die ("cannot open $gene_number");}
			print GENE ("$dna_txt");	
			close(GENE);	#
			if(!open(GENE,"$gene_number")){die ("cannot open $gene_number");}	#
			while(<GENE>){
				if($_=~/\<pre\>/){last;}	#it's still an HTML file,the fist several lines need to be passed
				}
			$gene_info_line=<GENE>;
#<!-- bget:db:genes --><!-- srr:SerAS9_3642 -->&gt;srr:SerAS9_3642 K01014 aryl sulfotransferase [EC:2.8.2.1] | (GenBank) sulfotransferase (A)	
#srr|p-Cresyl sulfate(pCS)/4-methylphenyl sulfate/p-cresol sulfate|Serratia plymuthica AS9		
			$gene_info_line=~/\-\-\>\&gt\;(\w+\:\w+)\s([K][0-9]+)\s(.+)\s.EC\:([0-9].+\w).\s\|\s(.+)\n/;	#read the standard head of a fasta file
#KEGG gene number,KO number,enzyme name,EC number,gene name from RefSeq or GenBank or no gene name;			
			$gene_info=$1."|".$2."|".$4." ".$3."|".$5."|".$toxin_name."|".$organism;	
			print DNAOUT ("$gene_info\n");
			while(<GENE>){
				if($_=~/\<\/pre\>\<\/div\>/){last;}
				print DNAOUT ("$_");
				}
			print DNAOUT ("\n");
			close(GENE);			
			unlink $gene_number;	#
			
			if(!open(GENE,">$gene_number")){die ("cannot open $gene_number");}
			print GENE ("$aa_txt");	
			close(GENE);	#
			if(!open(GENE,"$gene_number")){die ("cannot open $gene_number");}	#
			while(<GENE>){
				if($_=~/\<pre\>/){last;}	#it's still an HTML file,the fist several lines need to be passed
				}
			$gene_info_line=<GENE>;
#<!-- bget:db:genes --><!-- srr:SerAS9_3642 -->&gt;srr:SerAS9_3642 K01014 aryl sulfotransferase [EC:2.8.2.1] | (GenBank) sulfotransferase (A)	
#srr|p-Cresyl sulfate(pCS)/4-methylphenyl sulfate/p-cresol sulfate|Serratia plymuthica AS9		
			$gene_info_line=~/\-\-\>\&gt\;(\w+\:\w+)\s([K][0-9]+)\s(.+)\s.EC\:([0-9].+\w).\s\|\s(.+)\n/;	#read the standard head of a fasta file
#KEGG gene number,KO number,enzyme name,EC number,gene name from RefSeq or GenBank or no gene name;			
			$gene_info=$1."|".$2."|".$4." ".$3."|".$5."|".$toxin_name."|".$organism;	
			print AAOUT ("$gene_info\n");
			while(<GENE>){
				if($_=~/\<\/pre\>\<\/div\>/){last;}
				print AAOUT ("$_");
				}
			print AAOUT ("\n");
			close(GENE);			
			unlink $gene_number;	#        
			}
		close(NAME);#
		}
	close(EC);
	unlink $EC_number;	#
	}

close(DNAOUT);
close(AAOUT);
close(INFO);
