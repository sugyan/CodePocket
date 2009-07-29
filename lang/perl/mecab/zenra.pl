#!/opt/local/bin/perl
use strict;
use warnings;

use JSON 'decode_json';
use LWP::Simple 'get';
use Text::MeCab;
use Readonly;

Readonly::Scalar my $zenra => '全裸で';

# 引数に文章があればそれを対象に
my $text = shift;
if (defined $text) {
    print zenrize($text), "\n";
}
# 引数指定が無い場合はWassrのPublic Timelineを使用する
else {
    my $json = get 'http://api.wassr.jp/statuses/public_timeline.json';
    for my $status (@{decode_json $json}) {
        my $result = zenrize($status->{text});
        print "$result\n";
    }
}

# 日本語の文章を全裸にする
sub zenrize {
    my $text = shift;

    my $mecab = Text::MeCab->new();
    my $n = $mecab->parse($text);
    my $output = '';

    # 末尾まで進める
    $n = $n->next while ($n->next);

    my $flg = 0;
    # 末尾からさかのぼる
    while (($n = $n->prev)->prev) {
        # フラグがたっていれば「全裸で」を挿入
        # ただし、名詞／副詞／動詞のときはまだ挿入しない
        if ($flg) {
            my $insert = 1;
            if ($n->feature =~ / \A (名詞|副詞|動詞) /xms) {
                $insert = 0;
            }
            # また、連用形の動詞→助(動)詞の場合も挿入しない
            elsif ($n->feature =~ / \A 助(動)?詞 /xms &&
                       (split(/,/, $n->prev->feature))[5] =~ / 連用 /xms) {
                $insert = 0;
            }

            if ($insert) {
                $output = $zenra . $output;
                $flg = 0;
            }
        }

        # 出力の連結
        $output = $n->surface . $output;

        # 動詞を検出してフラグをたてる
        if ($n->feature =~ / \A 動詞 /xms) {
            $flg = 1;
        }
    }
    # 先頭のチェック
    if ($flg) {
        $output = $zenra . $output;
    }

    return $output;
}
