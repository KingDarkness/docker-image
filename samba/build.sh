#!/bin/bash
docker image rm kingdarkness/samba -f
docker build -t kingdarkness/samba -f Dockerfile .
docker push kingdarkness/samba