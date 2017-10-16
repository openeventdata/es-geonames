#### Search populated populated places by country code and name
```
GET geonames/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {"Name": "Salima"}
        }
      ],
      "filter": [
        {"term": {"CountryCode3.keyword": "MWI"}},
        {"term": {"FeatureClass.keyword": "P"}}
      ]
    }
  }
}
```
