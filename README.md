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

# Windows Installation
This segment concern windows, for some weird reason, using Git-Bash with `create_index.sh` will map the volume to `PROGRAM FILES\GIT\USR\SHARE\ELASTICSEARCH\DATA`
-> which mess up the docker volume.

I assume you already have dockerized elasticsearch:7.10.1 on your system, If not:
`docker pull elasticsearch:7.10.1`

To setup this repo on windows:
```
1. (Terminal) mkdir geoname_index
2. (Terminal) docker run -dp 127.0.0.1:9200:9200 -e "discovery.type=single-node" -v %cd%/geoname_index/:/usr/share/elasticsearch/data elasticsearch:7.10.1 
3. Download these stuff to this directory:
    - https://download.geonames.org/export/dump/allCountries.zip
    - https://download.geonames.org/export/dump/admin1CodesASCII.txt
    - https://download.geonames.org/export/dump/admin2Codes.txt
4. unzip allCountries.zip
5. (Git-Bash) create_index_windows.sh
```

The `geonames_index/` directory can be compressed and moved elsewhere. To start a new
Elasticsearch instance using the prepared index, run

```
docker run -d -p 127.0.0.1:9200:9200 -e "discovery.type=single-node" -v /PATH/TO/geoname_index/:/usr/share/elasticsearch/data elasticsearch:7.10.1
```
## Changes

April 2021: The fields in the Elasticsearch index have changed slightly and now
include `admin1_name` and `admin2_name` fields. See the
[mapping](https://github.com/openeventdata/es-geonames/blob/master/geonames_mapping.json)
for the new field names.