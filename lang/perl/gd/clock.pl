#!/opt/local/bin/perl
use strict;
use warnings;

use GD;
use Math::Trig 'pi';

my $image = GD::Image->new(300, 300);

# 色の設定
my $white = $image->colorAllocate(0xFF, 0xFF, 0xFF);
my $red   = $image->colorAllocate(0xFF, 0x00, 0x00);
my $blue  = $image->colorAllocate(0x00, 0x00, 0xFF);

# GIFデータの作成
my $gifdata = $image->gifanimbegin(1, 0);
for (0..60) {
    my $num = $_;
    # 各フレームの作成
    my $frame = GD::Image->new($image->getBounds);
    draw_frame($frame, $num);
    $gifdata .= $frame->gifanimadd(0, 0, 0, 1);
}
$gifdata .= $image->gifanimend;

# データの書き出し
binmode STDOUT;
print $gifdata;


sub draw_frame {
    my $image = shift;
    my $num   = shift;

    # (150, 150)を中心として直径240の円
    $image->arc(150, 150,
                240, 240,
                0, 360,
                $blue);
    # 線を描画
    my $x = 150 + 120 * sin(0);
    my $y = 150 - 120 * cos(0);
    for my $minute (map { $_ * 21 % 60 } 1..$num) {
        my $arg = $minute * pi / 30;
        my ($next_x, $next_y) = (150 + 120 * sin($arg), 150 - 120 * cos($arg));
        $image->line($x, $y, $next_x, $next_y, $red);
        ($x, $y) = ($next_x, $next_y);
    }
}
