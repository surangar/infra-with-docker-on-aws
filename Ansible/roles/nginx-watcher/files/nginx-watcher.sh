#!/bin/bash

URL=localhost
LOG_PATH=/var/log/index.html

while :
do

RESPONSE=$(curl --write-out %{http_code} --silent --output /dev/null ${URL})

if [ $RESPONSE -ne 200 ]
then
    echo "<p>Date:$(date +%Y%m%d_%H%M%S)" - "Service:Nginx - Status:Down" - "$(docker stats nginx --no-stream --format "CONTAINER:{{.Container}} - CPU%:{{.CPUPerc}} - Mem_Usage%:{{.MemUsage}} - NetIO:{{.NetIO}} - BlockIO:{{.BlockIO}} ")""</p >" >> $LOG_PATH
else
    echo "<p>Date:$(date +%Y%m%d_%H%M%S)" - "Service:Nginx - Status:Healthy" - "$(docker stats nginx --no-stream --format "CONTAINER:{{.Container}} - CPU%:{{.CPUPerc}} - Mem_Usage%:{{.MemUsage}} - NetIO:{{.NetIO}} - BlockIO:{{.BlockIO}} ")""</p >" >> $LOG_PATH
fi

sleep 10

done