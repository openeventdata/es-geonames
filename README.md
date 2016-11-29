Geonames gazetteer running in Elasticsearch
=======

wget http://download.geonames.org/export/dump/allCountries.zip

First, download and run the default Elasticsearch image:

```
docker run -d -p 9200:9200 elasticsearch:1.6 
```

Then load the gazetteer into Elasticsearch:

```
python geonames_elasticsearch_loader.py 
```

This takes about 25 minutes on an 8 core machine.

Next steps: use persistant storage.

https://docs.docker.com/engine/tutorials/dockervolumes/
