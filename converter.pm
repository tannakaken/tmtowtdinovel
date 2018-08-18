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

=pod

=encoding utf8

=head1 NAME

converter - 統一的な書式をそれぞれのファイルの書式へと変換する。

=head1 DESCRIPTION

一つの小説のソースから

=over 4

=item *

ただのテキストファイル

=item *

LaTeXを経由したpdfファイル

=item *

html/css/javascriptを使った動的なwebページ

=back

などを生成するために、統一的な書式で書かれたコマンドをそれぞれの書式へと変換するための関数を含む。

=head1 METHODS

=head2 overlap

二つの文字列が重なっていることを表現する文字列へと変換する。

=head3 SYNOPSIS

  $line = overlap($line, sub {my $left = shift; my $right = shift; return "\$ $left_{$right} \$";});

=head2 ruby

一つの文字列の上にもう一つの文字列がルビとして乗っていることを表現する文字列へと変換する。

=head3 SYNOPSIS

  $line = ruby($line, sub {my $left = shift; my $right = shift; return "\$ $left^{$right} \$";});

=head2 zipstring

二つの文字列を交互に混ぜ合わせた文字列を返す。

=head3 SYNOPSIS

  $ziped = zipstring("abcde", "123"); // => "a1b2c3de"

=head1 AUTHOR

淡中 圏 <tannakaken@gmail.com>

=cut
