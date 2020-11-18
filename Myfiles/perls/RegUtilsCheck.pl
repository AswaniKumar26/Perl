#!/usr/bin/perl

use RegTestUtils;
use Cwd qw();

my $modulePath = Cwd::abs_path();
my $testCaseName="data";
my @ignoreKeys = ("streetAddress");
my $result = RegTestUtils::CompareResults($modulePath,$testCaseName,\@ignoreKeys);

  if ($result == -1 ) {
     print "\n Content Mismatch\n";
  } else {
      print "\n Content Matched\n";
  }     	  
