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
docker run -d -p 127.0.0.1:9200:9200 -v /PATH/TO/geoname_index/data/:/usr/share/elasticsearch/data elasticsearch:7.10.1
```

where `/PATH/TO/geonames_index/data/` is the full path to the decompressed
index on your host machine. Depending on how you have Docker configured, you
may need to run this command with `sudo`.

This Geonames index is meant to be used with [Mordecai](https://github.com/openeventdata/mordecai), a full-text geoparser.

## Changes

April 2021: The fields in the Elasticsearch index have changed slightly and now
include `admin1_name` and `admin2_name` fields. See the
[mapping](https://github.com/openeventdata/es-geonames/blob/master/geonames_mapping.json)
for the new field names.
