#!/bin/bash
export APP_ENV="production"
docker image rm kingdarkness/lumen-php:8.2-fpm -f
docker build -t kingdarkness/lumen-php:8.2-fpm -f Dockerfile .
docker push kingdarkness/lumen-php:8.2-fpm

docker image rm kingdarkness/lumen-php:8.2-fpm-opcache -f
docker build -t kingdarkness/lumen-php:8.2-fpm-opcache -f opcache.Dockerfile .
docker push kingdarkness/lumen-php:8.2-fpm-opcache
