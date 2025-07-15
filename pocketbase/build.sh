#!/bin/bash
docker image rm kingdarkness/pocketbase:0.20.5 -f
docker build -t kingdarkness/pocketbase:0.20.5 -f Dockerfile .
docker push kingdarkness/pocketbase:0.20.5
