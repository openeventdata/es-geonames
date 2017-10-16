#!/usr/bin/env bash

export ES_GEONAMES_HOST=http://localhost:9200/
export ES_GEONAMES_USER=elastic
export ES_GEONAMES_PASSWORD=changeme
export ES_GEONAMES_INDEX=geonames2

# dont modify this if you download the files in the default location:
export ES_GEONAMES_FILE=$(pwd)\/allCountries.txt