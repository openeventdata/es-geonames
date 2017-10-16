# ES-GEONAMES transform and load with logstash
The same work for the python script but with posibilities to create the index based in the pipeline defined by the developer in the file `logstash-pipeline.conf`. This approach is good not only to send the data to ES but also to convert the Geonames CSV data to any [output](https://www.elastic.co/guide/en/logstash/current/output-plugins.html) we need. See at the end of this readme a JSON output sample. This method requires [logstash installed](https://www.elastic.co/guide/en/logstash/current/installing-logstash.html).

Some changes on the field names were performed, see the grok filter:

`
%{INT:GeonamesId}	%{DATA:Name}	%{DATA:ASCIIName}	%{DATA:AlternateNames}	%{DATA:Latitude}	%{DATA:Longitude}	%{DATA:FeatureClass}	%{DATA:FeatureCode}	%{DATA:CountryCode}	%{DATA:CountryCode2}	%{DATA:Admin1Code}	%{DATA:Admin2Code}	%{DATA:Admin3Code}	%{DATA:Admin4Code}	%{DATA:Population}	%{DATA:Elevation}	%{DATA:DEM}	%{DATA:Timezone}	%{GREEDYDATA:ModificationDate}"
`

According the pipeline, In some fields was improved the field type:

- `AlternateNames`: this list will be transformed from "alternatenames: comma separated, ascii names automatically transliterated, convenience attribute from alternatename table, varchar(10000)"
- `CountryCode2`: transformed from "cc2 : alternate country codes, comma separated, ISO-3166 2-letter country code, 200 characters"


As well as some new fields based on the codes list http://www.geonames.org/export/codes.html:

- `FeatureClass`
- `FeatureCode`
- and `CountryCode3`: based on the dict from the script `geonames_elasticsearch_loader.py`

### Usage

On the logstash folder:
- Copy `environment_variables.sample.sh` to `environment_variables.sh` with your environment vars.
- Run the index creator `sh create_index.sh`
- Start logstash `logstash -f logstash-pipeline.conf` it will take some seconds to start due big pipeline and will take just a few minutes to finish the ingest (2K per second in my i7 8G machine). The output log will look like `2017-09-01T12:09:14.354Z %{host} %{message}` as an info output for you to know when it finishes.
- Done, enjoy


### Todo
- Fine tune the mappings
- Load [premium data](http://www.geonames.org/products/premium-data-polygons.html) for example places as polygons are very interesting data to load as [ geo-shapes](https://www.elastic.co/guide/en/elasticsearch/reference/5.2/geo-shape.html).
- Dockerize
- Publish some Kibana stats


### JSON output sample
If looking for JSON output just comment the output > stout > `# codec => json`, sample:
```javascript
{
    "Timezone":"Asia/Kabul",
    "ASCIIName":"Pushtah-ye Amir Kushtah'i",
    "Latitude":35.24667,
    "FeatureCode":"MT",
    "type":"place",
    "AlternateNames":[
        "Poshteh-ye Amirkoshteh'i",
        "Poshteh-ye Amīrkoshteh’ī",
        "Pushtah-ye Amir Kushtah'i",
        "Pushtah-ye Amīr Kushtah’ī",
        "Pusta-i-Amirkusta'i",
        "Pusta-i-Amīṟkusta’i",
        "پشتۀ امیر کشته ئی"
    ],
    "Longitude":64.67254,
    "FeatureClass":"T",
    "DEM":"1847",
    "Name":"Pushtah-ye Amīr Kushtah’ī",
    "GeonamesId":1424592,
    "@timestamp":"2017-09-01T09:17:31.824Z",
    "FeatureClassName":"mountain, hill, rock, etc",
    "ModificationDate":"2012-01-19T00:00:00.000Z",
    "FeatureCodeName":"mountain",
    "@version":"1",
    "Admin1Code":"07",
    "Population":0,
    "location":{
        "lon":"64.67254",
        "lat":"35.24667"
    },
    "CountryCode":"AF",
    "CountryCode3":"AFG"
}
```


You can find this repo in the official [GEONAMES client libraries](http://www.geonames.org/export/client-libraries.html).

# Premium data
Premium data could be uploaded with the Logstash pipeline, as those updates are updated in a monthly basis, its ideal to keep the index up-to-date. The main requirement to use the premium data ingester is to run the free data first, if you did the steps above you are done, the logic behind update geonames is to download the data each month and run the commands at this moment.

`GeonamesID` is the key id for the documents, as the premium data references this ID, the logstash pipeline will update the existing places with the additional information:

## Airports

`
%{INT:GeonamesId}	%{DATA:Name}	%{DATA:FeatureCode}	%{DATA:CountryCode}	%{DATA:AdminCode1}	%{DATA:AdminCode2}	%{DATA:TimeZoneId}	%{DATA:Latitude}	%{DATA:Longitude}	%{DATA:IATA}	%{DATA:ICAO}	%{DATA:Unlocode}	%{DATA:CityId}	%{DATA:CityName}	%{DATA:IsActive}"
`

Pipeline will update place records where `GeonamesId` = indexed `GeonamesId` with:
- `IATA`:
- `ICAO`:
- `Unlocode`:
- `IsActive`:
