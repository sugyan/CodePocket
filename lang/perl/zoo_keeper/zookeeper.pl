#!/usr/bin/perl
use strict;
use warnings;

use utf8;
use Encode;
use Readonly;
use Term::Screen;
use Time::HiRes 'sleep';

Readonly my @animails => ('　', '猿', '鰐', '虎', '鯨', '豚', '象', '兎');

my $stage = init();

REMOVE_AND_FALL:
while (1) {
    my $result = remove($stage);
    last REMOVE_AND_FALL if !$result;
    fall($stage);
}

my ($x, $y) = (0, 0);
my $mark = 0;
my $result = 0;
my $total_point = 0;
my $screen = Term::Screen->new();

MAIN_LOOP:
while (1) {
    $screen->clrscr();
    # 描画
    for my $row (0..7) {
        $screen->at($row, 0);
        for my $col (0..7) {
            my $value = $stage->[$row][$col];
            my $color   = 30 + $value;
            my $bgcolor = 40;
            if (($x == $col) && ($y == $row)) {
                $color = 30 if ($color == 37);
                $bgcolor = 47;
            }
            print "\e[$color;$bgcolor", "m";
            print encode_utf8($animails[$value]);
        }
    }
    $screen->at(9, 0)->normal()->puts($total_point);
    if ($result) {
        sleep(0.5);
        fall($stage);
        $result = remove($stage);
        $total_point += $result;
        next MAIN_LOOP;
    }
    my $ch = $screen->getch();
    if ($mark) {
        # 交換
        my $src = [$y, $x];
        my $des = [$y, $x];
        $des->[1]-- if ($ch eq 'h');
        $des->[0]++ if ($ch eq 'j');
        $des->[0]-- if ($ch eq 'k');
        $des->[1]++ if ($ch eq 'l');
        change($stage, $src, $des);
        $result = remove($stage);
        $total_point += $result;
        # 消せない場合は戻す
        change($stage, $src, $des) if ($result == 0);
        $mark = 0;
    } else {
        # カーソル移動
        $x-- if ($ch eq 'h');
        $y++ if ($ch eq 'j');
        $y-- if ($ch eq 'k');
        $x++ if ($ch eq 'l');
    }
    $x = 0 if ($x < 0);
    $x = 7 if ($x > 7);
    $y = 0 if ($y < 0);
    $y = 7 if ($y > 7);
    # 現在地をマーク
    $mark = !$mark if ($ch eq ' ');
    # 終了
    last MAIN_LOOP if ($ch eq 'q');
}
$screen->normal();

# ランダムで8*8の数値を生成
sub init {
    return [ map {
        [ map {
            int(rand(7)) + 1;
        } 1..8 ];
    } 1..8 ];
}

# 縦or横に３つ以上並んでいるものを0に変更
# return : 0に変更した個数
sub remove {
    my $stage = shift;
    my $result = 0;    # 消去した数

    for my $row (0..7) {
        # 一時的にフラグを持つ
        for my $col (0..7) {
            my $value = $stage->[$row][$col];
            $stage->[$row][$col] = [$value, 1];
        }
        # 横判定
        for my $col (0..5) {
            my $value = $stage->[$row][$col + 0];
            my $next1 = $stage->[$row][$col + 1];
            my $next2 = $stage->[$row][$col + 2];
            if (($value->[0] == $next1->[0]) &&
                  ($value->[0] == $next2->[0])) {
                $value->[1] = 0;
                $next1->[1] = 0;
                $next2->[1] = 0;
            }
        }
    }

    for my $col (0..7) {
        # 縦判定
        for my $row (0..5) {
            my $value = $stage->[$row + 0][$col];
            my $next1 = $stage->[$row + 1][$col];
            my $next2 = $stage->[$row + 2][$col];
            if (($value->[0] == $next1->[0]) &&
                  ($value->[0] == $next2->[0])) {
                $value->[1] = 0;
                $next1->[1] = 0;
                $next2->[1] = 0;
            }
        }

        # フラグを判定に使用し、捨てる
        for my $row (0..7) {
            my $value = $stage->[$row][$col];
            if ($value->[1]) {
                $stage->[$row][$col] = $value->[0];
            } else {
                $stage->[$row][$col] = 0;
                $result++;
            }
        }
    }

    return $result;
}

# 0の部分を空白とみなし、下に詰めていく
sub fall {
    my $stage = shift;

    # 各列を調べる
    for my $col (0..7) {
        my @values = grep {
            # 0でないもの
            $_;
        } map {
            # $col列目の要素集合
            $_->[$col];
        } @$stage;

        # 空いている分を詰める
        while (@values < 8) {
            unshift(@values, int(rand(7)) + 1)
        }

        # 詰めた後のものを反映
        for my $row (0..7) {
            $stage->[$row][$col] = $values[$row];
        }
    }
}

# 要素の入れ替え
sub change {
    my ($stage, $src, $des) = @_;
    return if $des->[0] < 0;
    return if $des->[0] > 7;
    return if $des->[1] < 0;
    return if $des->[1] > 7;

    my $tmp = $stage->[$src->[0]][$src->[1]];
    $stage->[$src->[0]][$src->[1]] = $stage->[$des->[0]][$des->[1]];
    $stage->[$des->[0]][$des->[1]] = $tmp;
}
