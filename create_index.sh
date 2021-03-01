echo "Starting Docker container and data volume..."
sudo docker run -d -p 127.0.0.1:9200:9200 -e "discovery.type=single-node" -v /Users/ahalterman/MIT/Geolocation/es-geonames/geonames_index/:/usr/share/elasticsearch/data elasticsearch:7.10.1 

echo "Downloading Geonames gazetteer..."
wget http://download.geonames.org/export/dump/allCountries.zip
echo "Unpacking Geonames gazetteer..."
unzip allCountries.zip

echo "Creating mappings for the fields in the Geonames index..."
curl -XPUT 'localhost:9200/geonames' -H 'Content-Type: application/json' -d @geonames_mapping.json

echo "Loading gazetteer into Elasticsearch..."
python geonames_elasticsearch_loader.py

echo "Done"
