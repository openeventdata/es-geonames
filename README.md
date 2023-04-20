ES-Geonames
===========

Create a [Geonames](http://www.geonames.org/) index running locally in
Elasticsearch container. The index is stored in a data volume, which can be
moved elsewhere and quickly stood up.

To download the Geonames.org gazetter, set up Dockerized Elasticsearch, and
load the gazetteer into Elasticsearch, clone this repository and run

This repo is used to set this up on windows, for some weird reason, using Git-Bash with `create_index.sh` will map the volume to `PROGRAM FILES\GIT\USR\SHARE\ELASTICSEARCH\DATA`
-> which mess up the installation

I assume you already have dockerized elasticsearch:7.10.1 on your system, If not:
`docker pull elasticsearch:7.10.1`

To setup this repo on windows:
```
1. (Terminal) mkdir geonames_index
2. (Terminal) docker run -dp 127.0.0.1:9200:9200 -e "discovery.type=single-node" -v %cd%/geonames_index/:/usr/share/elasticsearch/data elasticsearch:7.10.1 
3. Download these stuff to this directory:
    - https://download.geonames.org/export/dump/allCountries.zip
    - https://download.geonames.org/export/dump/admin1CodesASCII.txt
    - https://download.geonames.org/export/dump/admin2Codes.txt
4. unzip allCountries.zip
5. (Git-Bash) create_index.sh
```

The `geonames_index/` now can be moved elsewhere. To mount it to another elasticsearch container do: 

```
docker run -dp 127.0.0.1:9200:9200 -e "discovery.type=single-node" -v /PATH/TO/geoname_index/data/:/usr/share/elasticsearch/data elasticsearch:7.10.1
```

where `/PATH/TO/geonames_index/data/` is the full path to the decompressed index on your host machine

This Geonames index is meant to be used with [Mordecai](https://github.com/openeventdata/mordecai), a full-text geoparser.
