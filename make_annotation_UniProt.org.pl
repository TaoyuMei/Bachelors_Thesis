#/usr/bin/perl
open(INFO,"uniprot_B.A.F_toxin.info")||die $!;
open(ANNO,">uniprot_B.A.F_toxin.org.anno")||die $!;

#print ANNO ("gene_ID\tgene_name\ttoxin_name\torganism\n");
while(<INFO>){
	$_=~s/\'/_/g;
	$_=~s/\#/_/g;
	$_=~s/\,/_/g;

	if($_=~/GN\=/){
		$_=~/\>(\S+)\s(.+)\sOS\=(.+)\sOX\=.+GN\=(.+)\sPE\=/;
		my $gene_ID=$1;
#		print ("$gene_ID");	#test, OK
		my $toxin_name=$2;
		my $organism=$3;
		my $gene_name=$4;
		print ANNO ("UniProt\t$gene_ID\t$gene_name\t$toxin_name\t$organism\n");
		if(!($gene_ID && $gene_name && $toxin_name && $organism)){
                        print("$_\n");
                        }
		}
	else{
		$_=~/\>(\S+)\s(.+)\sOS\=(.+)\sOX\=.+PE\=/;
                my $gene_ID=$1;
                my $toxin_name=$2;
                my $organism=$3;
                my $gene_name="NA";
		print ANNO ("UniProt\t$gene_ID\t$gene_name\t$toxin_name\t$organism\n");
		if(!($gene_ID && $gene_name && $toxin_name && $organism)){
			print("$_\n");
			}
		}
	#cannot print those element to ANNO here because they are contained in local variables	
	}

close(INFO);
close(ANNO);
