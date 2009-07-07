#!/opt/local/bin/perl
use strict;
use warnings;

use LWP::UserAgent;
use Text::MeCab;

my $mecab = Text::MeCab->new();
my $n = $mecab->parse($ARGV[0]);
my @nodes = ();     # 分かち書きしたものを一つの配列に入れる
my @noun = ();      # 名詞を検出した番号を格納する
my $index = 0;

while ($n = $n->next) {
    push(@nodes, $n->prev->surface);
    if ((split(/,/, $n->prev->feature))[0] eq '名詞') {
        push(@noun, $index);
    }
    $index++;
}

# 名詞からランダムに一つ選び出して置換する
my $replace = $noun[rand @noun];
$nodes[$replace] = 'kazuho';
print @nodes, "\n";


# Wassrのユーザー情報変更APIにPOSTする
my ($username, $password) = ('YOUR USER NAME', '**********');
my $url = 'http://api.wassr.jp/user/edit.json';
my $ua = LWP::UserAgent->new;
$ua->credentials(
    'api.wassr.jp:80',
    'API Authentication',
    $username,
    $password,
   );
$ua->post($url, { nick => join('', @nodes) });
