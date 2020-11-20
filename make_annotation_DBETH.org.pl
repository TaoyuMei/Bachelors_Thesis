#/usr/bin/perl
open(INFO,"Human_pathogenic_bacterial_exotoxin.info")||die $!;
open(ANNO,">Human_pathogenic_bacterial_exotoxin.org.anno")||die $!;

#print ANNO ("gene_ID\tgene_name\ttoxin_name\torganism\n");
while(<INFO>){
	if($_=~/GN\=/){	#among the 229 genes, 20 do not have gene name
		$_=~/\>(\S+)\s(.+)\sOS\=(.+)\sGN\=(.+)\sPE\=/;
		my $gene_ID=$1;
#		print ("$gene_ID");	#test, OK
		my $toxin_name=$2;
		my $organism=$3;
		my $gene_name=$4;
		print ANNO ("DBETH\t$gene_ID\t$gene_name\t$toxin_name\t$organism\n");
		}
	else{
		$_=~/\>(\S+)\s(.+)\sOS\=(.+)\sPE\=/;
                my $gene_ID=$1;
                my $toxin_name=$2;
                my $organism=$3;
		my $gene_name="NA";
                print ANNO ("DBETH\t$gene_ID\t$gene_name\t$toxin_name\t$organism\n");
		}
	#cannot print those element to ANNO here because they are contained in local variables	
	}

close(INFO);
close(ANNO);
