#!/bin/bash
docker image rm kingdarkness/mysql-backup -f
docker build -t kingdarkness/mysql-backup -f Dockerfile .
docker push kingdarkness/mysql-backup