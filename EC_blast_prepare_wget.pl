#!/usr/bin/perl
#perl EC_blast_prepare.pl [a file containing EC number and toxins information] [a file containing microorganisms names and abbreviations] 
#download HTML files containing enzyme information including genes' names and sequences links
#use LWP::Simple; 
use Getopt::Long;
my $EC_xls=@ARGV[0];	
my $abbre_name_micro=@ARGV[1];	
my $EC_xls_out_DNA=$EC_xls."toxin_genes_for_blast.fasta";	#2018.6.28
my $EC_xls_out_AA=$EC_xls."toxin_proteinss_for_blast.fasta";	#2018.6.28
my $EC_xls_error=$EC_xls."open_errors.txt";	#2018.6.28

if(!open(INFO,"$EC_xls")){die ("cannot open $EC_xls");}	
#if(!open(DNAOUT,">toxin_genes_for_blast.fasta")){die ("cannot open toxin_enzyme_genes_for_blast.fasta");}	#2018.4.30
#if(!open(AAOUT,">toxin_proteins_for_blast.fasta")){die ("cannot open toxin_enzyme_proteins_for_blast.fasta");}	#2018.4.30
#if(!open(ERROR,">download_and_open_errors.txt")){die ("cannot open download_and_open_errors.txt");}	#2018.4.30

open(DNAOUT,">$EC_xls_out_DNA")||die ("cannot open $EC_xls_out_DNA");	#2018.6.28
open(AAOUT,">$EC_xls_out_AA")||die ("cannot open $EC_xls_out_AA");	#2018.6.28
open(ERROR,">$EC_xls_error")||die ("cannot open $EC_xls_error");	#2018.6.28
	
while(<INFO>){	
	
	$_=~/(.*)\t.*\t.*\t(.*)\t.*\t.*\n/;	#read toxin name and EC number, store in $1 and $2 respectively	
	my $toxin_name=$1;
	my $EC_number=$2;
	my $EC_url="https://www.kegg.jp/entry/ec:".$EC_number;	 

	`wget -O $EC_number $EC_url > /dev/null`;	#use shell wget
	if(!open(EC,"$EC_number")){	#if cannot open the file containing Enzyme information,record and skip
		print ERROR ("cannot open $EC_number\n");
		next;	#next <INFO> line
		}
	while(<EC>){	#skip informaiton before the enzyme gene
		if($_=~/\<nobr\>Genes\<\/nobr\>/){last;}
		}
	my $Genes=<EC>;	#all gene information is included in one line in the html file
#<a href="/dbget-bin/www_bget?ecy:ECSE_0185">ECSE_0185</a>	
	my @organism_gene=$Genes=~m/\<a\shref\=\"\/dbget\-bin\/www_bget\?[a-z][a-z][a-z]*\:\w+\"\>\w+\<\/a\>/g;

	foreach my $href (@organism_gene){	#extract gene number and organism name

		$href=~/\<a\shref\=\"\/dbget\-bin\/www_bget\?([a-z][a-z][a-z]*\:\w+)\"\>\w+\<\/a\>/;	
		my $gene_number=$1;
		$href=~/\<a\shref\=\"\/dbget\-bin\/www_bget\?([a-z][a-z][a-z]*)\:\w+\"\>\w+\<\/a\>/;	#
		my $organism=$1;
#		print("$EC_number by $organism");	#test
		if(!open(NAME,"$abbre_name_micro")){die ("cannot open $abbre_name_micro");}
		while(<NAME>){	#filter the organisms,keep the fungi and prokaryote,convert their abbreviations to names
			if($_=~/^E\s\s\s\s\s\s\s\s([a-z][a-z][a-z]*)\s\s(.+)/){	#
				if($1 eq $organism){$organism=$2;}	#
				}
			elsif($_=~/^D\s\s\s\s\s\s([a-z][a-z][a-z]*)\s\s(.+)/){	#
				if($1 eq $organism){$organism=$2;}
				}
#			else {print("microorganism cannot produce $EC_number");}	#test 
			}
		close(NAME);	#close the abbre-name file, open it next time to read it from the first line
		
		if(length($organism)>4){	#only when an abbreviation has been converted to a name will its length>4 
#http://www.kegg.jp/dbget-bin/www_bget?-f+-n+n+eco:b0186  DNA sequence
#http://www.kegg.jp/dbget-bin/www_bget?-f+-n+a+eco:b0186  AA sequence
			my $dna_url="https://www.kegg.jp/entry/-f+-n+n+".$gene_number;	
			my $aa_url="https://www.kegg.jp/entry/-f+-n+a+".$gene_number;	
			$gene_number=~/(\w*):(\w*)/;	#file name cannot contain ":" in windows system
			$gene_number=$1.".".$2;
			my $dna=$gene_number."dna";
			my $aa=$gene_number."aa";

			`wget -O $dna $dna_url /dev/null`;
			
				if(!open(GENEDNA,"$dna")){print ERROR ("cannot open $dna\n");}	#
				else{	#if open the html file successfully,then extract fasta	
					while(<GENEDNA>){	#skip useless lines
						if($_=~/\<pre\>/){last;}	
						}
					my $gene_info_line=<GENEDNA>;
#<!-- bget:db:genes --><!-- srr:SerAS9_3642 -->&gt;srr:SerAS9_3642 K01014 aryl sulfotransferase [EC:2.8.2.1] | (GenBank) sulfotransferase (A)	
#srr|p-Cresyl sulfate(pCS)/4-methylphenyl sulfate/p-cresol sulfate|Serratia plymuthica AS9		
					$gene_info_line=~/\-\-\>\&gt\;(.+)\s(K[0-9]+)\s(.+)\s.EC.+\s\|\s(.+)\n/;	#read the standard head of a fasta file
#KEGG gene number,KO number,enzyme name,EC number,gene name from RefSeq or GenBank or no gene name;			
					my $gene_info=">".$1."|".$2."|".$EC_number." ".$3."|".$4."|".$toxin_name."|".$organism;	#create a new fasta head according to MSV format
					print DNAOUT ("$gene_info\n");
					while(<GENEDNA>){	#print the sequence
						if($_=~/\<\/pre\>\<\/div\>/){last;}
						print DNAOUT ("$_");
						}
					print DNAOUT ("\n");
					close(GENEDNA);			
					}
				unlink $dna;	#as long as the html file has been downloaded,delete it here regardless of whether it can be opened	
				

			`wget -O $aa $aa_url > /dev/null`;
							
				if(!open(GENEAA,"$aa")){print ERROR ("cannot open $aa");}	
				else{
					while(<GENEAA>){	#skip useless lines
						if($_=~/\<pre\>/){last;}	
						}
					$gene_info_line=<GENEAA>;
#<!-- bget:db:genes --><!-- srr:SerAS9_3642 -->&gt;srr:SerAS9_3642 K01014 aryl sulfotransferase [EC:2.8.2.1] | (GenBank) sulfotransferase (A)	
#srr|p-Cresyl sulfate(pCS)/4-methylphenyl sulfate/p-cresol sulfate|Serratia plymuthica AS9		
					$gene_info_line=~/\-\-\>\&gt\;(.+)\s(K[0-9]+)\s(.+)\s.EC.+\s\|\s(.+)\n/;	#read the standard head of a fasta file
#KEGG gene number,KO number,enzyme name,EC number,gene name from RefSeq or GenBank or no gene name;			
					$gene_info=">".$1."|".$2."|".$EC_number." ".$3."|".$4."|".$toxin_name."|".$organism;	#create a new fasta head according the MSV format
					print AAOUT ("$gene_info\n");
					while(<GENEAA>){	#extract the amino acid sequence
						if($_=~/\<\/pre\>\<\/div\>/){last;}
						print AAOUT ("$_");
						}
					print AAOUT ("\n");
					close(GENEAA);			      
					}
				unlink $aa;	#as long as the html file has been downloaded,delete it here regardless of whether it can be opened
				
			}
		}
	close(EC);
	unlink $EC_number;	#
		
	}
close(INFO);
close(DNAOUT);
close(AAOUT);
close(ERROR);
