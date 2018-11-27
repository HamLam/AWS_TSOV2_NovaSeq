#!/usr/bin/perl

 use strict;
 use warnings;

  die "Usage: Check_Genes.pl <cnv_returned_genes_file> <Submitted_genes_file>\n"
  unless @ARGV == 2;


  my ($CNV_genes, $Submitted_genes) = @ARGV;

  open CNV_Genes_File, "<$CNV_genes"
    or die "Can't open $CNV_genes: $!\n";

  open SubmittedGenesFile, "<$Submitted_genes"
    or die "Can't open $Submitted_genes: $!\n";

  open (my $fh, '>', 'Missed_Genes') or die "Could not open file 'Missed_Genes file' $!";


## building a hash to hold cnv returned genes
## assume file has one gene per line

 my %CNV_Genes_Hash;

 while(<CNV_Genes_File>){
  chomp;
  my $key = $_;
   $CNV_Genes_Hash{$key}=0;
   }

## check cnv returned genes against the submitted genes in the while loop
## each gene in Submitted gene file is checked against the CNV_Genes_hash

my $found_counter=0;
my $missed_counter=0;

while(<SubmittedGenesFile>){
 chomp;
   my $g = $_;
  (my $VAL)=matching($g, \%CNV_Genes_Hash);
  if ($VAL == 1){
      $found_counter++;
   }else{
     $missed_counter++;
  }
}


print "Total genes processed: ", $found_counter,"\n";
print "Total genes missed: ", $missed_counter,"\n";

sub matching{
 my $v1;
 my ($key, $hash_ref) = @_;
     if(defined $hash_ref -> {$key}){
     $v1=1;
  }else{
        print $fh $key,"\n";
        # print "Missed: ", $key, "\n";
        $v1=0;
    }
  return($v1);
}

close(CNV_Genes_File);
close(SubmittedGenesFile);
