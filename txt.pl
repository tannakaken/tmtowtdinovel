use strict;
use warnings;

use Encode qw/decode encode/;

sub zipstring {
  my $a = shift;
  my $b = shift;
  if (!@{$a}) {
    return join('',@{$b});
  } elsif (!@{$b}) {
    return join('',@{$a});
  } else {
    return shift(@{$a}) . shift(@{$b}) . zipstring($a,$b);
  }
}

my $overlap_pattern = '\\\\overlap\{(.*?)\}\{(.*?)\}';

sub overlap {
  my $line = shift;
  while ($line =~ /$overlap_pattern/) {
    my $overlaped = zipstring([split(//,$1)], [split(//,$2)]);
    $line =~ s/$overlap_pattern/$overlaped/;
  }
  return $line;
}

my $ruby_pattern = '\\\\ruby\{(.*?)\}\{(.*?)\}';

sub ruby {
  my $line = shift;
  while ($line =~ /$ruby_pattern/) {
    my $rubyed = "$1($2)";
    $line =~ s/$ruby_pattern/$rubyed/;
  }
  return $line;
}

my $text = "";
my $new = 1;
while (my $line = <>) {
  $line = decode('UTF-8', $line);
  chomp($line);
  $line = overlap($line);
  $line = ruby($line);
  if ($line eq '*****') {
    $text .= "\n$line\n\n";
    next;
  }
  if ($new) {
    if ($line eq '') {
      next;
    } else {
      $text .= decode('UTF-8', '　') . $line;
      $new = 0;
    }
  } else {
    if ($line eq '') {
      $text .= "\n";
      $new = 1;
    } else {
      $text .= $line;
    }
  }
}
print encode('UTF-8', $text);
