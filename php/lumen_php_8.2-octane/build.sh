#!/bin/bash
export APP_ENV="production"
docker image rm kingdarkness/lumen-php:8.2-octane -f
docker build -t kingdarkness/lumen-php:8.2-octane -f Dockerfile .
docker push kingdarkness/lumen-php:8.2-octane
