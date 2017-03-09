# Example of using es-geonames from R
# Andy Halterman

# I just manually construct the request with a string. This isn't beautiful, but it
#  makes it easy to use the wealth of example code online.
# This example is built to look for a given place name in a given governoate in Syria.
# You should modify the request to match your use case by using the Elasticsearch DSL.
query_geonames <- function(area_name, admin1_code){
  body <- paste0('{
    "query": {
       "bool": {
          "must" : {
              "query_string": {
                    "query": "', area_name, '",
                    "fields" : ["asciiname^5", "alternativenames"]
                    }
            },
            "filter": {
                "bool" : {
                  "should" : [
                    {"term": {"admin1_code": "', admin1_code, '"}},
                    {"term": {"country_code3" : "SYR"}}
                ]
            }
        }
     }
   }
  }')
  
resp <- httr::POST(url = "http://localhost:9200/geonames/_search?pretty", body = body)
return(resp)
}

resp <- query_geonames("Yabroud", "08")


# A helper function to deal with the JSON that comes back.
tidy_results <- function(hit, n_hits, area_name){
  hit <- hit$`_source`
  n <- hit$name
  coords <- hit$coordinates
  coords_split <- strsplit(coords, split = ",")[[1]]
  cc <- hit$country_code3
  feature_code <- hit$feature_code
  feature_class <- hit$feature_class
  return(data.frame(name = n,
                    lat = coords_split[1],
                    lon = coords_split[2],
                    country = cc,
                    feature_class = feature_class,
                    feature_code = feature_code,
                    geonameid = hit$geonameid,
                    n_hits = n_hits,
                    search_term = area_name,
                    stringsAsFactors = FALSE))
}


tidied <- lapply(httr::content(resp)$hits$hits, tidy_results, length(httr::content(resp)), area_name = "Rif Dimashq")


