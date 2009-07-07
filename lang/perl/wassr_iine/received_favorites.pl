#!/opt/local/bin/perl
use strict;
use warnings;

use Encode;
use Web::Scraper;
use URI;

# ユーザー情報
my $user = scraper {
    process "a",
      "screen_name" => 'TEXT';
    process "a",
      "user_login_id" => '@href';
};

# 発言の内容
my $scraper = scraper {
    process "div.favorited_user_list > form",
      "favorite_users[]" => $user;
    process "div.MsgBody > p",
      "description" => 'TEXT';
};

# イイネをもらった発言
my $messages = scraper {
    process "div.favorited_message",
      "favorited_messages[]" => $scraper;
};

my $uri = URI->new('http://wassr.jp/user/sugyan/received_favorites');
for my $message (@{$messages->scrape($uri)->{favorited_messages}}) {
    print encode_utf8 $message->{description}, "\n";
    print encode_utf8 join ' ', map {
        $_->{screen_name};
    } @{$message->{favorite_users}};
    print "\n\n";
}
