use strict;
use warnings;

use Encode qw/decode encode/;

use lib '.';
use converter;

my $text = "";
my $new = 1;
while (my $line = <>) {
  $line = decode('UTF-8', $line);
  chomp($line);
  $line = overlap($line, \&zipstring);
  $line = ruby($line, sub {
    my $main = shift;
    my $ruby = shift;
    return "$main($ruby)";
  });
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

=pod

=encoding utf8

=head1 NAME

txt.pl - テキストファイルを生成するスクリプト。

=head1 DESCRIPTION

小説ファイルからテキストファイルを生成する。

=head1 SYNOPSIS

  perl txt.pl main.txt > dist/novel.txt

=head1 AUTHOR

淡中 圏 <tannakaken@gmail.com>

=cut
