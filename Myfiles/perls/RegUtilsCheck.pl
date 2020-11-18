#!/usr/bin/perl

use RegTestUtils;
use Cwd qw();

my $modulePath = Cwd::abs_path();
my $result = RegTestUtils::CompareResults($modulePath);

  if ($result == -1 ) {
     print "\n Content Mismatch\n";
  } else {
      print "\n Content Matched\n";
  }     	  
