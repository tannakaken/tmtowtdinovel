use strict;
use warnings;

use Encode qw/decode encode/;

use lib '.';
use converter;

my $conf_file = './conf.perl';
my $conf = do $conf_file or die "$!$@";

my $text = decode('UTF-8', <<EOS);
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>$conf->{'title'}</title>
    <style>

    body {
      background-color : #90ee90;
    }
    h1 {
      text-align : center;
      background-color : black;
      color : white;
    }
    h2 {
      text-align : center;
    }
    section {
      background-color : white;
      width : 60%;
      margin : 5px auto;
      padding : 20px;
    }
    \@media screen and (max-width: 800px) {
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
    span.overlap {
      text-indent : 0;
    }
    span.first {
      position : absolute;
    }
    span.second {
      opacity : 0.0;
    }
    
    </style>
  </head>
  <body>
    <h1>$conf->{'title'}</h1>
    <h2>$conf->{'author'} (<a href="$conf->{'github'}">github</a>)</h2>
    <section id="one">
      <p>
EOS

my $new = 1;
my $section = 2;
my @numbers = qw/zero one two three four five size seven eight nine ten/;
while (my $line = <>) {
  $line = decode('UTF-8', $line);
  chomp($line);
  $line = overlap($line, sub {
    my $left = shift;
    my $right = shift;
    my ($len_l, $len_r) = (length($left), length($right));
    my $len = $len_l > $len_r ? $len_l : $len_r;
    return <<EOS;
<span class="overlap" style="display : inline-block; width : ${len}em;"><span class="first">$left</span><span class="second">$right</span></span>
EOS
  });
  $line = ruby($line, sub {
    my $main = shift;
    my $ruby = shift;
    return "<ruby>$main<rp>(</rp><rt>$ruby</rt><rp>)</rp></ruby>";
  });
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
  <script>
    window.addEventListener('load', function() {
      let opacity = 1.0;
      let d = -0.1;
      let firsts = document.getElementsByClassName('first');
      let seconds = document.getElementsByClassName('second');
      let length = firsts.length;
      setInterval(function() {
        let new_opacity = opacity + d;
        if (new_opacity <= 0.0) {
          opacity = 0.0;
          d = -d
        } else if (new_opacity + d >= 1.0) {
          opacity = 1.0
          d = -d;
        } else {
          opacity = new_opacity;
        }
        for (let i = 0; i < length; i++) {
            firsts[i].style.opacity = opacity.toString();
            seconds[i].style.opacity = (1 - opacity).toString();
        }
      }, 100);
    }, false);
  </script>
</html>
EOS

print encode('UTF-8', $text);

=pod

=encoding utf8

=head1 NAME

html.pl - 動的なwebページのためのhtmlファイルを生成するスクリプト。

=head1 DESCRIPTION

小説ファイルからhtmlファイルを生成する。

=head1 SYNOPSIS

  perl html.pl main.txt > dist/novel.html

=head1 AUTHOR

淡中 圏 <tannakaken@gmail.com>

=cut
