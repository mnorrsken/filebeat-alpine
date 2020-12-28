# filebeat-alpine
Slimmed filebeat multi arch (linux/arm/v7, linux/arm64, linux/amd64) alpine image. Logging to stdout. Created to be used on multi arch cluster as sidecar to traefik.

### Input config files in
/config/inputs

### Module config files in
/config/modules

### ELASTICSEARCH_HOSTS
Default es host value is elasticsearch-master:9200, otherwise specify ELASTICSEARCH_HOSTS env variable
