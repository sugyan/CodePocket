#!/usr/bin/env python
# -*- coding:utf-8 -*-

import codecs
import feedparser
import sys
from xmlrpclib import ServerProxy

sys.stdout = codecs.getwriter('utf_8')(sys.stdout)

if __name__ == '__main__':
    try:
        # アカウント名取得
        user = sys.argv[1]
    
        # 新着ブックマーク
        rss = 'http://b.hatena.ne.jp/bookmarklist.rss?url=http%3A%2F%2Fd.hatena.ne.jp%2F' + user
        feed = feedparser.parse(rss)
        for entry in reversed(feed['entries']):
            # 記事のタイトルは entry['title'] で取得
            date = "%4d/%02d/%02d" % entry['updated_parsed'][:3]
            print '%s %s: %s' % (date, entry['author'], entry['summary'])

        # 被ブックマーク総数
        server = ServerProxy('http://b.hatena.ne.jp/xmlrpc')
        total = server.bookmark.getTotalCount('http://d.hatena.ne.jp/' + user)
        print 'total: %d' % (total)
    
    except IndexError:
        print 'usage: ./hatebu.py <your_hatena_id>'
