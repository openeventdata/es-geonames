ES-Geonames
===========

Create a [Geonames](http://www.geonames.org/) index running locally in
Elasticsearch container. The index is stored in a data volume, which can be
moved elsewhere and quickly stood up.

To download the Geonames.org gazetter, set up Dockerized Elasticsearch, and
load the gazetteer into Elasticsearch, clone this repository and run

```
bash create_index.sh
```

The `geonames_index/` directory can be compressed and moved elsewhere. To start a new
Elasticsearch instance using the prepared index, run

```
sudo docker run -d -p 127.0.0.1:9200:9200 -v /PATH/TO/geoname_index/data/:/usr/share/elasticsearch/data elasticsearch:5.1.2
```

where `/PATH/TO/geonames_index/data/` is the full path to the decompressed
index on your host machine.

This Geonames index is meant to be used with OEDA's [full text geoparse,
Mordecai](https://github.com/openeventdata/mordecai).

ES-Geonames with Logstash
=========================

The same work for the python script but with posibilities to create the index based in the pipeline defined by the developer in the file `logstash/logstash-pipeline.conf`. See logstash folder.