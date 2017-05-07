# docker-nba-etl

[![Build Status](https://travis-ci.org/AtzeDeVries/travisci-nba-etl-docker.svg?branch=master)](https://travis-ci.org/AtzeDeVries/travisci-nba-etl-docker)

### Running
This docker image can be used to run a import using the NBA ETL module.
The by default the import data is not in the container. You should bindmount it.

```shell
docker run --rm \
  -v /path/to/your/data:/payload/data \
  -v /path/for/logs:/payload/software/log \
  --link your-es-container:es docker-nba-etl:V2.3 ./import-all.sh
```
Your data directory (/path/to/your/data) should contain the folders
```
brahms
col
crs
geo
medialib
ndff
nsr
```

You can also overwrite settings with environment variables (from version V2.3-20-g461dab56 and up) posibilities (with defaults) are
```shell
ES_DNS=es
DEFAULT_SHARDS=12
NUM_REPLICAS=0
NBA_INDEX_NAME=nba
COL_YEAR=2016
PURL_BASE_URL=''
TEST_GENERA=#test_genera=malus,parus,larus,bombus,rhododendron,felix,tulipa,rosa,canis,passer,trientalis
```


You also need an elasticsearch 5.1.2 instance.

Before running elasticsearch make sure you have your `vm.max_map_count` setting correct
To check run

`/sbin/sysctl  vm.max_map_count`

It should be `262144` or higher
To modify run

`/sbin/sysctl -w vm.max_map_count=262144`

Run `5.1.2`:
```shell
docker run --name my-es5-01 \
  -d -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
  elasticsearch:5.1.2 elasticsearch \
    -Ecluster.name="nba-cluster" \
    -Enetwork.host="_site_"
```

In a full nba cluster, elasticsearch should be already setup. If you want a own elasticsearch server, make sure you have enough disk and memory and modify the settings `-Xms` and `-Xmx`. The values of `-Xms` and `-Xmx` shoud be the same.

### Running it with auto import
You can also now run it in a fully automated way, with auto download of source data. You then need to set the following values (defaults are show)
```shell
AUTO_IMPORT=TRUE (default false)
IMPORT_DATA_DIR=/payload/data (dont really change unless you are sure)
IMPORT_COMMAND=./import-all
GIT_URL_PREFIX=https://github.com/naturalis/
CONSOLE_LOG=TRUE (default is false)
REPOS="nba-brondata-nsr:master,nba-brondata-medialib:master,nba-brondata-crs:master,nba-brondata-col:master,nba-brondata-brahms:master,nba-brondata-geo:master"
```
so running:
```shell
docker run --name my-import-job -e AUTO_IMPORT=TRUE docker-nba-etl:V2.3-20-g461dab56
```
Will download data for nsr,medialib,crs,col and brahms and run `./import_all`

The data directory to which the data will be cloned is `/payload/data` + the last part of the git repository name. So nba-brondata-nsr
will be cloned to `/payload/data/nsr`

If you for example just want to import Geo you run
```shell
docker run --name geo-import-job \
    -e REPOS="nba-brondata-geo:master" \
    -e IMPORT_COMMAND="./bootstrap GeoAreas && ./geo-import" \
    -e "AUTO_IMPORT=TRUE"
    docker-nba-etl:V2.3-20-g461dab56
```
