use strict;
use warnings;

use Encode qw/decode encode/;

use lib '.';
use converter;

my $conf_file = './conf.perl';
my $conf = do $conf_file or die "$!$@";

my $text = decode('UTF-8', <<EOS);
\\documentclass{ltjsarticle}
\\usepackage{amsmath}
\\usepackage{pxrubrica}
\\usepackage{url}
\\usepackage{hyperref}

\\title{$conf->{'title'}}
\\date{}
\\author{$conf->{'author'}}

\\begin{document}
\\maketitle
EOS

while (my $line = <>) {
  $line = decode('UTF-8', $line);
  $line = overlap($line, sub {
      my $left = shift;
      my $right = shift;
      return "{\\scriptsize \$\\begin{cases} \\text{$left} \\\\ \\text{$right} \\end{cases} \$}"
  });
  $line = ruby($line, sub {
      my $main = shift;
      my $ruby = shift;
      return "\\ruby[g]{$main}{$ruby}";
  });
  if ($line eq "*****\n") {
    $text .= '\newpage' . "\n";
  } else {
    $text .= $line;
  }
}

$text .= decode('UTF-8', <<EOS);
\\footnote{githubページ:\\url{$conf->{'github'}}}
\\end{document}
EOS

print encode('UTF-8', $text);

=pod

=encoding utf8

=head1 NAME

pdf.pl - pdfを生成するためのLuaLaTeXファイルを生成するスクリプト。

=head1 DESCRIPTION

小説ファイルからLuaLaTeXファイルを生成する。

=head1 SYNOPSIS

  perl pdf.pl main.txt > dist/novel.tex
  cd dist
  lualatex novel.tex

=head1 AUTHOR

淡中 圏 <tannakaken@gmail.com>

=cut
