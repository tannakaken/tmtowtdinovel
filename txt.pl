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

sub mix {
  my $line = shift;
  while ($line =~ /\#\{(.*?)\}\{(.*?)\}/) {
    my $mixed = zipstring([split(//,$1)], [split(//,$2)]);
    $line =~ s/\#\{.*?\}\{.*?\}/$mixed/;
  }
  return $line;
}


my $text = "";
my $new = 1;
while (my $line = <>) {
  $line = decode('UTF-8', $line);
  chomp($line);
  $line = mix($line);
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
