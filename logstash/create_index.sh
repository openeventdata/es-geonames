echo "Setting env vars..."
source environment_variables.sample.sh

echo "Downloading Geonames gazetteer..."
wget http://download.geonames.org/export/dump/allCountries.zip
echo "Unpacking Geonames gazetteer..."
unzip allCountries.zip

#echo "Starting Docker container and data volume..."
#sudo docker run -d -p 127.0.0.1:9200:9200 -v $PWD/geonames_index/:/usr/share/elasticsearch/data elasticsearch:5.1.2
#sleep 10s

echo "Creating mappings for the fields in the Geonames index:"
echo ${ES_GEONAMES_HOST}${ES_GEONAMES_INDEX}
curl -XPUT ${ES_GEONAMES_HOST}${ES_GEONAMES_INDEX} -H 'Content-Type: application/json' -d @geonames_mapping.json

echo "Done"
