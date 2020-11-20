#/usr/bin/perl
open(INFO,"Human_pathogenic_bacterial_exotoxin.info")||die $!;
open(ANNO,">Human_pathogenic_bacterial_exotoxin.anno")||die $!;

print ANNO ("gene_ID\tgene_name\ttoxin_name\tGenus\tGenus_Species\tSub\_Species\_and\_Strain\n");
while(<INFO>){
	if($_=~/GN\=/){	#among the 229 genes, 20 do not have gene name
		$_=~/\>(\S+)\s(.+)\sOS\=(\S+)\s(\S+)(.*)GN\=(.+)\sPE\=/;
		my $gene_ID=$1;
#		print ("$gene_ID");	#test, OK
		my $toxin_name=$2;
		my $Genus=$3;
		my $Species=$4;
		my $Subsp_Strain=$5;
		my $gene_name=$6;
		if($Subsp_Strain=~/\S/){
			$Subsp_Strain=~/\s(.+)\s/;
			$Subsp_Strain=$1;
			}
		else{$Subsp_Strain="NA";}
		print ANNO ("$gene_ID\t$gene_name\t$toxin_name\t$Genus\t$Genus\_$Species\t$Subsp_Strain\n");
		}
	else{
		$_=~/\>(\S+)\s(.+)\sOS\=(\S+)\s(\S+)(.*)PE\=/;
                my $gene_ID=$1;
                my $toxin_name=$2;
                my $Genus=$3;
                my $Species=$4;
                my $Subsp_Strain=$5;
                my $gene_name="NA";
		if($Subsp_Strain=~/\S/){
                        $Subsp_Strain=~/\s(.+)\s/;
                        $Subsp_Strain=$1;
                        }
                else{$Subsp_Strain="NA";}
		print ANNO ("$gene_ID\t$gene_name\t$toxin_name\t$Genus\t$Genus\_$Species\t$Subsp_Strain\n");
		}
	#cannot print those element to ANNO here because they are contained in local variables	
	}

close(INFO);
close(ANNO);
