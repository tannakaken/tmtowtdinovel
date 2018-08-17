use strict;
use warnings;

use Encode qw/decode encode/;

sub mix {
  my $line = shift;
  while ($line =~ /\#\{(.*?)\}\{(.*?)\}/) {
    my $cases = <<EOS;
<span class="overlap"><span class="first">$1</span><span class="second">$2</span></span>
EOS
    $line =~ s/\#\{.*?\}\{.*?\}/$cases/;
  }
  return $line;
}

my $text = decode('UTF-8', <<'EOS');
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <title>悪夢</title>
    <style>
    body {
      background-color : #90ee90;
    }
    h1 {
      text-align : center;
      background-color : black;
      color : white;
    }
    section {
      background-color : white;
      width : 60%;
      margin : 5px auto;
      padding : 20px;
    }
    @media screen and (max-width: 800px) {
      section {
        width: 90%;
      }
    }
    section#two {
      background-color : gray;
      color : white;
    }
    p {
      text-indent : 1em;
    }
    </style>
  </head>
  <body>
    <h1>悪夢</h1>
    <section id="one">
      <p>
EOS
my $new = 1;
my $section = 2;
my @numbers = qw/zero one two three four five size seven eight nine ten/;
while (my $line = <>) {
  $line = decode('UTF-8', $line);
  chomp($line);
  $line = mix($line);
  if ($line eq "*****") {
    $text .= <<EOS;
    </section>
    <section id="$numbers[$section]">
    <p>
EOS
    $section++;
    next;
  }
  if ($new) {
    if ($line eq '') {
      next;
    } else {
      $text .= $line;
      $new = 0;
    }
  } else {
    if ($line eq '') {
      $text .= "</p><p>\n";
      $new = 1;
    } else {
      $text .= $line;
    }
  }
}

$text .= <<'EOS';
  </body>
</html>
EOS

print encode('UTF-8', $text);
