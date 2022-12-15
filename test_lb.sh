#!/bin/bash

echo "Network Creating...."
docker network create normal_py310_default1 >/dev/null 2>&1
docker network create normal_py310_default2 >/dev/null 2>&1
docker network create normal_py310_default3 >/dev/null 2>&1
docker network create normal_py310_default4 >/dev/null 2>&1

echo "Build...."
docker build -t fastapi-py310-normal-keep-alive api-keep-alive >/dev/null 2>&1
docker build -t fastapi-py310-normal-keep-alive-long api-keep-alive-long >/dev/null 2>&1
docker build -t node-fetch-client node-fetch-client >/dev/null 2>&1

echo "Start Server...."
docker rm fastapi-py310-normal-1  >/dev/null 2>&1
docker rm fastapi-py310-normal-2  >/dev/null 2>&1
docker rm fastapi-py310-normal-3  >/dev/null 2>&1
docker rm fastapi-py310-normal-4  >/dev/null 2>&1
docker rm node-fetch-client-async-disable-disable > /dev/null 2>&1
docker rm node-fetch-client-async-disable-enable > /dev/null 2>&1
docker rm node-fetch-client-async-enable-disable > /dev/null 2>&1
docker rm node-fetch-client-async-enable-enable > /dev/null 2>&1

docker rm lb-1 > /dev/null 2>&1
docker rm lb-2 > /dev/null 2>&1
docker rm lb-3 > /dev/null 2>&1
docker rm lb-4 > /dev/null 2>&1

docker run --name fastapi-py310-normal-1 --network normal_py310_default1 -p 15000:5000 -d fastapi-py310-normal-keep-alive >/dev/null 2>&1
docker run --name fastapi-py310-normal-2 --network normal_py310_default2 -p 15001:5000 -d fastapi-py310-normal-keep-alive >/dev/null 2>&1
docker run --name fastapi-py310-normal-3 --network normal_py310_default3 -p 15002:5000 -d fastapi-py310-normal-keep-alive-long >/dev/null 2>&1
docker run --name fastapi-py310-normal-4 --network normal_py310_default4 -p 15003:5000 -d fastapi-py310-normal-keep-alive-long >/dev/null 2>&1

docker run --name lb-1 --network normal_py310_default1 -d -v $(PWD)/reverse-proxy/nginx1.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1
docker run --name lb-2 --network normal_py310_default2 -d -v $(PWD)/reverse-proxy/nginx2.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1
docker run --name lb-3 --network normal_py310_default3 -d -v $(PWD)/reverse-proxy/nginx3.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1
docker run --name lb-4 --network normal_py310_default4 -d -v $(PWD)/reverse-proxy/nginx4.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1

echo "Initial Mem Usage"
echo "=========================================="
docker stats fastapi-py310-normal-1 fastapi-py310-normal-2 fastapi-py310-normal-3 fastapi-py310-normal-4 --no-stream --format "{{.Name}}: {{.MemUsage}}"
echo "=========================================="
echo "Run bench mark with node-fetch-client(no keep-alive/10000Req/Async) & FastAPI(enable keep-alive(with lb))"
docker run --name node-fetch-client-async-disable-disable --network normal_py310_default1 -e TARGET_URL="http://lb-1/" -e REQUEST_NUM=50 -e CYCLE_NUM=200 node-fetch-client ./run.sh >/dev/null 2>&1
sleep 3
echo "=========================================="
echo "Run bench mark with node-fetch-client(enable keep-alive/10000Req/Async) & FastAPI(enable keep-alive(with lb))"
docker run --name node-fetch-client-async-enable-disable --network normal_py310_default2 -e TARGET_URL="http://lb-2/" -e ENABLE_KEEP_ALIVE=true  -e REQUEST_NUM=50 -e CYCLE_NUM=200 node-fetch-client ./run.sh  >/dev/null 2>&1
sleep 3
echo "=========================================="
echo "Run bench mark with node-fetch-client(no keep-alive/10000Req/Async) & FastAPI(enable keep-alive-long(with lb))"
docker run --name node-fetch-client-async-disable-enable --network normal_py310_default3 -e TARGET_URL="http://lb-3/" -e REQUEST_NUM=50 -e CYCLE_NUM=200 node-fetch-client ./run.sh >/dev/null 2>&1
sleep 3
echo "=========================================="
echo "Run bench mark with node-fetch-client(enable keep-alive/10000Req/Async) & FastAPI(enable keep-alive(with lb))"
docker run --name node-fetch-client-async-enable-enable --network normal_py310_default4 -e TARGET_URL="http://lb-4/" -e ENABLE_KEEP_ALIVE=true -e REQUEST_NUM=50 -e CYCLE_NUM=200 node-fetch-client ./run.sh >/dev/null 2>&1
echo "=========================================="
echo "After Requests Mem Usage"
docker stats fastapi-py310-normal-1 fastapi-py310-normal-2 fastapi-py310-normal-3 fastapi-py310-normal-4 --no-stream --format "{{.Name}}: {{.MemUsage}}"

echo "=[SUMMARY] ECONNRESET ===================="
echo "keepalive(server): enabled, keepalive(client): disabled"
docker logs node-fetch-client-async-disable-disable | grep -c "errno: 'ECONNRESET',"
echo "keepalive(server): enabled, keepalive(client): enabled"
docker logs node-fetch-client-async-disable-enable | grep -c "errno: 'ECONNRESET',"
echo "keepalive(server): enabled(long), keepalive(client): disabled"
docker logs node-fetch-client-async-enable-disable | grep -c "errno: 'ECONNRESET',"
echo "keepalive(server): enabled(long), keepalive(client): enabled"
docker logs node-fetch-client-async-enable-enable | grep -c "errno: 'ECONNRESET',"
echo "=[SUMMARY] load balancer reset ===================="
echo "keepalive(server): enabled, keepalive(client): disabled"
docker logs lb-1 2>&1 | grep -c "reset by peer"
echo "keepalive(server): enabled, keepalive(client): enabled"
docker logs lb-2 2>&1 | grep -c "reset by peer"
echo "keepalive(server): enabled(long), keepalive(client): disabled"
docker logs lb-3 2>&1 | grep -c "reset by peer"
echo "keepalive(server): enabled(long), keepalive(client): enabled"
docker logs lb-4 2>&1 | grep -c "reset by peer"
echo "=[SUMMARY] Worker process shutdown ======="
echo "keepalive(server): enabled, keepalive(client): disabled"
docker logs fastapi-py310-normal-1 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled, keepalive(client): enabled"
docker logs fastapi-py310-normal-2 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled(long), keepalive(client): disabled"
docker logs fastapi-py310-normal-3 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled(long), keepalive(client): enabled"
docker logs fastapi-py310-normal-4 2>&1 | grep -c 'shutdown complete'

echo "=========================================="
echo "Cleanup...."
docker stop fastapi-py310-normal-1 >/dev/null 2>&1
docker stop fastapi-py310-normal-2 >/dev/null 2>&1
docker stop fastapi-py310-normal-3 >/dev/null 2>&1
docker stop fastapi-py310-normal-4 >/dev/null 2>&1
docker stop node-fetch-client-async-disable-disable > /dev/null 2>&1
docker stop node-fetch-client-async-disable-enable > /dev/null 2>&1
docker stop node-fetch-client-async-enable-disable > /dev/null 2>&1
docker stop node-fetch-client-async-enable-enable > /dev/null 2>&1

docker stop lb-1 > /dev/null 2>&1
docker stop lb-2 > /dev/null 2>&1
docker stop lb-3 > /dev/null 2>&1
docker stop lb-4 > /dev/null 2>&1
echo "=========================================="
docker network rm normal_py310_default1 normal_py310_default2 normal_py310_default3 normal_py310_default4 >/dev/null 2>&1
