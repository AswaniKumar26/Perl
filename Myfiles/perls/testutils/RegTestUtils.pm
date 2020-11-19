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
my $DATAFILE = ".txt";

# Process and iterarte Array and see if any array or hash
# if so iterate them and remove till the actual key is reached.
sub processArrayAndRemove {

  my $key = $_[0];
  my $keys = $_[1];
  my $i;
  for ($i=0; $i <= $#$keys; $i++) {
      my $curVal = $keys->[$i];
      if( ref $curVal eq 'ARRAY') {
        processArrayAndRemove($key,$curVal);
      } elsif( ref $curVal eq 'HASH' ) {
        processHashAndRemove($key,$curVal);
      }
  }
}


sub processHashAndRemove {
  my $key = $_[0];
  my $object = $_[1];

  foreach my $objKey (keys %$object) {
      my $curVal = $object->{$objKey};
      if($key eq $objKey ) {
         delete $object->{$objKey};
      }
      elsif( ref $curVal eq 'ARRAY') {
        processArrayAndRemove($key,$curVal);
      } elsif( ref $curVal eq 'HASH' ) {
        processHashAndRemove($key,$curVal);
      } else {
         if( $key eq $objKey)  {
             delete $object->{$objKey};
         }
      }
  }
}




sub removeKeys {
  my $key = $_[0];
  my $object = $_[1];

  foreach my $objKey (keys %$object) {
      my $curVal = $object->{$objKey};
      if($key eq $objKey) {
          delete $object->{$key};
      }
      elsif( ref $curVal eq 'ARRAY') {
        processArrayAndRemove($key,$curVal);
      } elsif( ref $curVal eq 'HASH' ) {
        processHashAndRemove($key,$curVal);
      } else {
         if($key eq $objKey ) {
             delete $object->{$key};
         }
      }
  }

}

sub removeIgnorableKeys {
  my $keys    =   $_[0];
  my $object  =   $_[1];
  
  my $i;
  for ($i=0; $i <= $#$keys; $i++) {
      my $currKey = $keys->[$i];
      removeKeys($currKey, $object);
  }

}



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


sub convertJson2PerlObject{
    my $content = $_[0];
    my $convertedData = decode_json($content);
    return $convertedData;

}

sub CompareResults {
    my $currModulePath = $_[0];
    my $testcasename = $_[1];
    my $arrayRef = $_[2];
    my $baseLineFile = $currModulePath."/".$BASELINE."/".$testcasename.$DATAFILE;
    my $actualFile = $currModulePath."/".$ACTUAL."/".$testcasename.$DATAFILE;
    
    # Read Data from baseline files
    my $baselineContent = ReadFile($baseLineFile);
    
    # Translate string into perl Object
    my $baselineData = convertJson2PerlObject($baselineContent);
    
    # Remove Ignorable fields from the perl object compariosion.
    removeIgnorableKeys($arrayRef,$baselineData);

    my $identical;
    
    # Read data from actual response file
    my $actualContent=ReadFile($actualFile);
    
    # Convert string into Perl Object
    my $actualData = convertJson2PerlObject($actualContent);
    
    # Remove ignorable keys from perl object before perl comparision
    removeIgnorableKeys($arrayRef,$actualData);

    ################################################
    print "\n#########BASELINE DUMP##################\n";
    print  Dumper($baselineData);
    print "\n########################################\n";

    ################################################
    print "\n#########ACTUAL DUMP####################\n";
    print  Dumper($actualData);
    print "\n########################################\n";
    
    # Compare both the results for comparision
    my $result = new Data::Compare($baselineData,$actualData);
    if($result->Cmp) {
        $identical =1;
     } else {
        $identical =-1;
     }

     my @diff = data_diff($baselineData, $actualData);
     print "\n##########DIFFERENCE####################\n";
     print Dumper(@diff);
     print "\n########################################\n";

     return $identical;
}   

1;
