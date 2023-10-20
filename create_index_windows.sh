# echo "Starting Docker container and data volume..."
# # create the directory first to avoid permission issues when Docker is running as root
# mkdir $PWD/geonames_index/
# docker run -d -p 127.0.0.1:9200:9200 -e "discovery.type=single-node" -v $PWD/geonames_index/:/usr/share/elasticsearch/data elasticsearch:7.10.1 

# echo "Downloading Geonames gazetteer..."
# wget https://download.geonames.org/export/dump/allCountries.zip
# wget https://download.geonames.org/export/dump/admin1CodesASCII.txt
# wget https://download.geonames.org/export/dump/admin2Codes.txt
# echo "Unpacking Geonames gazetteer..."
# unzip allCountries.zip

echo "Creating mappings for the fields in the Geonames index..."
curl -XPUT 'localhost:9200/geonames' -H 'Content-Type: application/json' -d @geonames_mapping.json

echo "Change disk availability limits..."
curl -X PUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.disk.watermark.low": "10gb",
    "cluster.routing.allocation.disk.watermark.high": "5gb",
    "cluster.routing.allocation.disk.watermark.flood_stage": "4gb",
    "cluster.info.update.interval": "1m"
  }
}
'

echo "\nLoading gazetteer into Elasticsearch..."
python geonames_elasticsearch_loader.py

echo "Done"
