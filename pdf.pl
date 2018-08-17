use strict;
use warnings;

use Encode qw/decode encode/;

sub mix {
  my $line = shift;
  while ($line =~ /\#\{(.*?)\}\{(.*?)\}/) {
    my $cases = <<EOS;
{\\scriptsize \$\\begin{cases} \\text{$1} \\\\ \\text{$2} \\end{cases} \$}
EOS
    $line =~ s/\#\{.*?\}\{.*?\}/$cases/;
  }
  return $line;
}

my $text = decode('UTF-8', <<'EOS');
\documentclass{ltjsarticle}
\usepackage{amsmath}

\title{悪夢}
\date{}
\author{Tannakian Cat}

\begin{document}
\maketitle
EOS
while (my $line = <>) {
  $line = decode('UTF-8', $line);
  $line = mix($line);
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
