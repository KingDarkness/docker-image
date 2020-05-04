#!/bin/bash
docker image rm kingdarkness/lumen-php:7.3-apache-stretch -f
docker build -t kingdarkness/lumen-php:7.3-apache-stretch -f Dockerfile .
docker push kingdarkness/lumen-php:7.3-apache-stretch