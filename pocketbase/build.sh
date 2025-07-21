#!/bin/bash
docker image rm kingdarkness/pocketbase:0.28.4 -f
docker build -t kingdarkness/pocketbase:0.28.4 -f Dockerfile .
docker push kingdarkness/pocketbase:0.28.4
