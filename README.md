ES-Geonames
===========

Create a Geonames index running locally in Elasticsearch container. The index
is stored in a data volume, which can be moved elsewhere and quickly stood up.

To download the Geonames.org gazetter, set up Dockerized Elasticsearch, and
load the gazetteer into Elasticsearch, simply run

```
bash create_index.sh
```

The `data/` directory can be compressed and moved elsewhere. To start a new
Elasticsearch instance using the prepared index, run

```
sudo docker run -d -p 127.0.0.1:9200:9200 -v /path/to/data/:/usr/share/elasticsearch/data elasticsearch
```

where `/path/to/data/` is the full path to the decompressed index.
