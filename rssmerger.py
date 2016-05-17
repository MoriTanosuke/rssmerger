#!/usr/bin/python
import datetime
import feedgenerator
import feedparser
import http.server
import socketserver
import time
from os import curdir, sep, path

PORT = 8000
urls = [
    {
        'url': "http://blog.kopis.de/feed.xml"
    },
    {
        'url': "https://www.kopis.de/tt/public.php?op=rss&id=-2&view-mode=all_articles&key=af7d97f5762ec3f4de058ab70e53b30514d88857",
        'prefix': 'Link: '
    }
]

class RssRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.endswith(".xsl"):
            filepath = curdir + sep + self.path
            if path.isfile(filepath):
                self.send_response(200)
                self.send_header('Content-type', 'application/xslt+xml')
                self.end_headers()
                f = open(filepath)
                self.wfile.write(bytearray(f.read(), 'UTF-8'))
                f.close()
            else:
                self.send_response(404)

        elif self.path.endswith(".rss") or self.path.endswith(".xml"):
            all_items = []

            for element in urls:
                feed = feedparser.parse(element["url"])
                for item in feed["items"]:
                    if "prefix" in element:
                        item.title = element["prefix"] + item.title
                    all_items.append(item)

            ordered_items = sorted(all_items, key=lambda entry: entry["date_parsed"])
            ordered_items.reverse()

            # build a new feed with all items in order
            rss = feedgenerator.Rss201rev2Feed(
                title="KOPIS.DE Aggregate feed",
                link="http://www.kopis.de",
                description="Aggregate feed for KOPIS.DE using several sources",
                lastBuildDate=datetime.datetime.now()
            )

            for item in ordered_items:
                rss.add_item(
                    title=item.title,
                    link=item.link,
                    description=item.description,
                    pubdate=datetime.datetime.fromtimestamp(time.mktime(item.date_parsed)),
                    unique_id=item.guid
                )

            self.send_response(200)
            self.send_header('Content-type', 'application/xml')
            self.end_headers()
            # TODO insert XSL after <?xml version="1.0" encoding="utf-8"?>
            #self.wfile.write(bytearray('<?xml-stylesheet type="text/xsl" href="atom-to-html.xsl"?>', 'UTF-8'))
            self.wfile.write(bytearray(rss.writeString('UTF-8'), 'UTF-8'))

        else:
            self.send_response(404)

        return

# serve via HTTP
handler = RssRequestHandler
httpd = socketserver.TCPServer(("", PORT), handler)

print("serving at port", PORT)
httpd.serve_forever()
