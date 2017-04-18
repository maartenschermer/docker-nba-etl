FROM openjdk:8-alpine
MAINTAINER atze.devries@naturalis.nl
RUN mkdir /payload
RUN apk add --no-cache bash
WORKDIR /payload
ADD software software
RUN mkdir data
ADD version /payload/software/sh/version
ENV LOG_LEVEL INFO
ADD log4j2.xml /payload/software/conf/log4j2.xml
WORKDIR /payload/software/sh
