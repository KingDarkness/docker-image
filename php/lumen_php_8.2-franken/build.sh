#!/bin/bash
export APP_ENV="production"
docker image rm kingdarkness/lumen-php:8.2-franken -f
docker build -t kingdarkness/lumen-php:8.2-franken -f Dockerfile .
docker push kingdarkness/lumen-php:8.2-franken

docker image rm kingdarkness/lumen-php:8.2-franken-opcache -f
docker build -t kingdarkness/lumen-php:8.2-franken-opcache -f opcache.Dockerfile .
docker push kingdarkness/lumen-php:8.2-franken-opcache
