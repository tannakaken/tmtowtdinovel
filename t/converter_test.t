use strict;
use warnings;

use lib '.';
use converter;

use Test::More tests => 3;
{
  my $line = 'overlap \overlap{over}{lap} overlap';
  my $callback = sub {
    my $left = shift;
    my $right = shift;
    return "($left|$right)";
  };
  my $expect = 'overlap (over|lap) overlap';
  is(overlap($line, $callback), $expect ,'overlap test'); 
}

{
  my $line = 'ruby \ruby{ru}{by} ruby';
  my $callback = sub {
    my $left = shift;
    my $right = shift;
    return "($left|$right)";
  };
  my $expect = 'ruby (ru|by) ruby';
  is(ruby($line, $callback), $expect ,'ruby test'); 
}

{
  is(zipstring('abc', '12345'), 'a1b2c345', 'zipstring test');
}

done_testing;
