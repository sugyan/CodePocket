#!/opt/local/bin/perl
use strict;
use warnings;

use Web::Scraper;
use URI;

# 取得する要素
my $scraper = scraper {
    process '#home_left img',
      'images[]' => '@src';
    process 'span.pages',
      'page' => 'TEXT';
};

# 取得先URI
my $base_uri = 'http://asianposes.com/category/pose/';
my $uri = URI->new($base_uri);

PAGE:
while (1) {
    # スクレイピング
    my $result = $scraper->scrape($uri);

    # 取得した画像URIを出力
    for my $image (@{$result->{images}}) {
        print "$image\n";
    }

    # ページの判定
    my ($current, $total);
    if ($result->{page} =~ m{(\d+) \s* of \s* (\d+)}xms) {
        ($current, $total) = ($1, $2);
    }
    # 最終ページだったら終了
    last PAGE if ($current == $total);

    # 次のページを探しに行く
    $uri = URI->new($base_uri . 'page/' . ($current + 1) . '/');
}
