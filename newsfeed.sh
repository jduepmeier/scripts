#!/bin/bash
###########
# get headlines from rss feeds
###########

URL="http://feeds.feedburner.com/blogspot/rkEL?format=xml"

TICKER=`curl -f -s "$URL"`
echo $TICKER | \
sed -e 's/<\/title>/<\/title>\n/g' -e 's/<title>/\n<title>/g' | \
grep "</title>" | \
sed -e 's/<[\/]*title>//g' \
-e '/^Der\ Postillon/d' \
-e '/^Newsticker/d' \
-e '/^Links!\ Zwo!\ Drei!\ Vier!/d'
