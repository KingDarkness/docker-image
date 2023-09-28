#!/bin/bash
export APP_ENV="production"
docker image rm kingdarkness/lumen-php:8.2-apache-socket -f
docker build -t kingdarkness/lumen-php:8.2-apache-socket -f Dockerfile .
docker push kingdarkness/lumen-php:8.2-apache-socket

docker image rm kingdarkness/lumen-php:8.2-apache-socket-opcache -f
docker build -t kingdarkness/lumen-php:8.2-apache-socket-opcache -f opcache.Dockerfile .
docker push kingdarkness/lumen-php:8.2-apache-socket-opcache
