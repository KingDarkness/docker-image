#!/bin/bash
export APP_ENV="production"
docker image rm kingdarkness/lumen-php:8.1-apache-socket -f
docker build -t kingdarkness/lumen-php:8.1-apache-socket -f Dockerfile .
docker push kingdarkness/lumen-php:8.1-apache-socket

docker image rm kingdarkness/lumen-php:8.1-apache-socket-opcache -f
docker build -t kingdarkness/lumen-php:8.1-apache-socket-opcache -f opcache.Dockerfile .
docker push kingdarkness/lumen-php:8.1-apache-socket-opcache
