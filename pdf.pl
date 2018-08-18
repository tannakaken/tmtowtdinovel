use strict;
use warnings;

use Encode qw/decode encode/;

my $overlap_pattern = '\\\\overlap\{(.*?)\}\{(.*?)\}';

sub overlap {
  my $line = shift;
  while ($line =~ /$overlap_pattern/) {
    my $overlaped = <<EOS;
{\\scriptsize \$\\begin{cases} \\text{$1} \\\\ \\text{$2} \\end{cases} \$}
EOS
    $line =~ s/$overlap_pattern/$overlaped/;
  }
  return $line;
}

my $ruby_pattern = '\\\\ruby\{(.*?)\}\{(.*?)\}';

sub ruby {
  my $line = shift;
  while ($line =~ /$ruby_pattern/) {
    my $rubyed = "\\ruby[g]{$1}{$2}";
    $line =~ s/$ruby_pattern/$rubyed/;
  }
  return $line;
}


my $text = decode('UTF-8', <<'EOS');
\documentclass{ltjsarticle}
\usepackage{amsmath}
\usepackage{pxrubrica}

\title{悪夢}
\date{}
\author{Tannakian Cat}

\begin{document}
\maketitle
EOS

while (my $line = <>) {
  $line = decode('UTF-8', $line);
  $line = overlap($line);
  $line = ruby($line);
  if ($line eq "*****\n") {
    $text .= '\newpage' . "\n";
  } else {
    $text .= $line;
  }
}

$text .= <<'EOS';
\end{document}
EOS

print encode('UTF-8', $text);
