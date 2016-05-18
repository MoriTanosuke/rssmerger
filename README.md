This is a simple python script which aggregates multiple RSS feeds into a single feed. Each feed can have a prefix,
which is added to the title of each feed item.

Needs python3.

Start locally
-------------

Make sure you have [Docker][0] installed. Then run the following commands in the directory:

    docker build -t rssmerger .
    docker run --rm -it -p 9876:8000

Now you can access the merged feed at [http://localhost:9876/feed.xml][1].

[0]: https://www.docker.com/
[1]: http://localhost:9876/feed.xml
