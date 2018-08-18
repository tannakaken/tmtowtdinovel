use Exporter;
@ISA = (Exporter);
@EXPORT = qw/overlap ruby zipstring/;

use strict;
use warnings;

sub converter_for_two_arguments {
  my $line = shift;
  my $callback = shift;
  my $pattern = shift;
  while ($line =~ /$pattern/) {
    my $converted = $callback->($1, $2);
    $line =~ s/$pattern/$converted/;
  }
  return $line;
}

my $overlap_pattern = '\\\\overlap\{(.*?)\}\{(.*?)\}';

sub overlap {
  my $line = shift;
  my $callback = shift;
  return converter_for_two_arguments($line, $callback, $overlap_pattern);
}

my $ruby_pattern = '\\\\ruby\{(.*?)\}\{(.*?)\}';

sub ruby {
  my $line = shift;
  my $callback = shift;
  return converter_for_two_arguments($line, $callback, $ruby_pattern);
}

sub zipstring {
  my $left = shift;
  my $right = shift;
  return zip_array_to_string([split(//, $left)], [split(//, $right)]);
}

sub zip_array_to_string {
  my $a = shift;
  my $b = shift;
  if (!@{$a}) {
    return join('',@{$b});
  } elsif (!@{$b}) {
    return join('',@{$a});
  } else {
    return shift(@{$a}) . shift(@{$b}) . zip_array_to_string($a,$b);
  }
}

1;
