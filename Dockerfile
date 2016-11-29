FROM ubuntu:14.04

MAINTAINER Andy Halterman <ahalterman0@gmail.com>

RUN apt-get update
RUN apt-get install -y python2.7 python-pip python-dev build-essential curl
RUN apt-get install -y openjdk-7-jre wget
#RUN pip install pyelasticsearch

RUN mkdir /app
WORKDIR /app

RUN wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.0/elasticsearch-2.4.0.deb
RUN dpkg -i elasticsearch-2.4.0.deb

COPY allCountries.txt .
COPY geonames_elasticsearch_loader.py .
RUN update-rc.d elasticsearch defaults
RUN curl -XGET http://localhost:9200

RUN python geonames_elasticsearch_loader.py

EXPOSE 9200

CMD ["/etc/init.d/elasticsearch", "start"]
