#!/bin/bash

echo "Jenkins build started..."
curl -X GET http://47.102.131.179:9090/job/Code-Server/build?token=Code-Server
