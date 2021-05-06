#!/bin/bash
docker image rm kingdarkness/xmrig -f
docker build -t kingdarkness/xmrig -f Dockerfile .
docker push kingdarkness/xmrig