package RegTestUtils;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(CompareResults);
use strict;
use JSON;
use Data::Dumper;
use Data::Compare;
use Data::Difference qw(data_diff);

my $BASELINE = "Baseline";
my $ACTUAL   = "Actual";
my $DATAFILE = "data.txt";


sub ReadFile {
   my $file =$_[0];
   my $fileContent;
   open(FH, '<', $file) or die $!;

   while(my $row = <FH>){
      $fileContent = $fileContent . $row; 
   }

   close(FH);    
   return $fileContent;
}	

sub CompareResults {
   my $currModulePath = $_[0];
   my $baseLineFile = $currModulePath."/".$BASELINE."/".$DATAFILE;
   my $actualFile = $currModulePath."/".$ACTUAL."/".$DATAFILE;

   my $baselineContent = ReadFile($baseLineFile);
   my $baselineData = decode_json($baselineContent);
   my $identical;


  my $actualContent=ReadFile($actualFile);
  my $actualData = decode_json($actualContent);

  ################################################
  #print "\n#########BASELINE DUMP##################\n";
  #print  Dumper($baselineData);
  #print "\n########################################\n";

  ################################################
  #print "\n#########ACTUAL DUMP####################\n";
  #print  Dumper($actualData);
  #print "\n########################################\n";
  
  my $result = new Data::Compare($baselineData,$actualData);
  #print Dumper($result);
  #print "\n Compare: $result->Cmp \n";
  #print Dumper($result->Cmp);
  if($result->Cmp) {
    #print "\n Entererd If \n";
    $identical =1;
  } else {
    #print "\n Entered Else \n";
    $identical =-1;
  }
  my @diff = data_diff($baselineData, $actualData);
  print "\n##########DIFFERENCE####################\n";
  print Dumper(@diff);
  print "\n########################################\n";

   return $identical;
}   

1;
