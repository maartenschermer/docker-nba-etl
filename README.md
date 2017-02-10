# docker-nba-etl

This docker image can be used to run a import using the NBA ETL module.
The import data is not in the container. You should bindmount it.

```
docker run --rm \
  -v /path/to/your/data:/payload/data \
  -v /path/for/logs:/payload/software/log \
  --link your-es-container:es sh/import-all.sh
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

You also need an elasticsearch 5.1.2 instance.

Before running elasticsearch make sure you have your `vm.max_map_count` setting correct
To check run

`/sbin/sysctl  vm.max_map_count`

It should be `262144` or higher
To modify run

`/sbin/sysctl -w vm.max_map_count=262144`

Run `5.1.2`:
```
docker run --name my-es5-01 \
  -d -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
  elasticsearch:5.1.2 elasticsearch \
    -Ecluster.name="nba-cluster" \
    -Enetwork.host="_site_"
```

In a full nba cluster, elasticsearch should be already setup. If you want a own elasticsearch server, make sure you have enough disk and memory and modify the settings `-Xms` and `-Xmx`. The values of `-Xms` and `-Xmx` shoud be the same.
