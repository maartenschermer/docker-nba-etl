FROM openjdk:8-alpine
MAINTAINER atze.devries@naturalis.nl

ENV ES_DNS=es DEFAULT_SHARDS=12 NUM_REPLICAS=0 NBA_INDEX_NAME=nba COL_YEAR=2016 PURL_BASE_URL='' 
ENV TEST_GENERA=#test_genera=malus,parus,larus,bombus,rhododendron,felix,tulipa,rosa,canis,passer,trientalis
ENV AUTO_IMPORT=FALSE GIT_URL_PREFIX=https://github.com/naturalis/ IMPORT_DATA_DIR=/payload/data IMPORT_COMMAND=./import-all CONSOLE_LOG=FALSE
ENV REPOS="nba-brondata-nsr:master,nba-brondata-medialib:master,nba-brondata-crs:master,nba-brondata-col:master,nba-brondata-brahms:master,nba-brondata-geo:master"
RUN mkdir /payload
RUN apk add --no-cache bash git
WORKDIR /payload
ADD software software
RUN mkdir data
ADD version /payload/software/sh/version
ENV LOG_LEVEL INFO
ADD log4j2.xml /payload/software/conf/log4j2.xml
WORKDIR /payload/software/sh
ADD run.sh run.sh
ADD version version
RUN chmod +x run.sh
CMD ./run.sh
