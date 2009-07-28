#!/opt/local/bin/perl
use strict;
use warnings;

use JSON 'decode_json';
use LWP::Simple 'get';
use Text::MeCab;
use Readonly;

Readonly::Scalar my $kohmi => 'ゲレンデがとけるほど';

my $json = get 'http://api.wassr.jp/statuses/public_timeline.json';
for my $status (@{decode_json $json}) {
    my $result = kohming($status->{text});
    print "$result\n";
}

sub kohming {
    my $text = shift;

    my $mecab = Text::MeCab->new();
    my $n = $mecab->parse($text);
    my $output = '';

    # 末尾まで進める
    $n = $n->next while ($n->next);

    my $flg = 0;
    # 末尾からさかのぼる
    while (($n = $n->prev)->prev) {
        # フラグがたっていれば挿入候補位置
        if ($flg) {
            # 名詞／副詞のときはまだ挿入しない
            if ($n->feature !~ / \A (名詞|副詞) /xms) {
                $output = $kohmi . $output;
                $flg = 0;
            }
        }

        # 出力の連結
        $output = $n->surface . $output;

        # 動詞／形容詞を検出してフラグをたてる
        if ($n->feature =~ / \A (動詞|形容詞) /xms) {
            $flg = 1;
        }
    }
    # 先頭のチェック
    if ($flg) {
        $output = $kohmi . $output;
    }

    return $output;
}
