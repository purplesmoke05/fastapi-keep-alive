#!/bin/bash

echo "Network Creating...."
docker network create normal_py311_default1 >/dev/null 2>&1
docker network create normal_py311_default2 >/dev/null 2>&1
docker network create normal_py311_default3 >/dev/null 2>&1
docker network create normal_py311_default4 >/dev/null 2>&1

echo "Build...."
docker build -t fastapi-py311-normal-keep-alive api-keep-alive
docker build -t fastapi-py311-normal-keep-alive-long api-keep-alive-long

echo "Start Server...."
docker rm fastapi-py311-normal-1  >/dev/null 2>&1
docker rm fastapi-py311-normal-2  >/dev/null 2>&1
docker rm fastapi-py311-normal-3  >/dev/null 2>&1
docker rm fastapi-py311-normal-4  >/dev/null 2>&1
docker rm case-1 > /dev/null 2>&1
docker rm case-2 > /dev/null 2>&1
docker rm case-3 > /dev/null 2>&1
docker rm case-4 > /dev/null 2>&1

docker rm lb-1 > /dev/null 2>&1
docker rm lb-2 > /dev/null 2>&1
docker rm lb-3 > /dev/null 2>&1
docker rm lb-4 > /dev/null 2>&1

docker run --sysctl net.core.somaxconn=65535 --sysctl net.ipv4.tcp_rmem="253952 253952 16777216" --sysctl net.ipv4.tcp_wmem="253952 253952 16777216" --name fastapi-py311-normal-1 --network normal_py311_default1 -p 15000:5000 -d fastapi-py311-normal-keep-alive >/dev/null 2>&1
docker run --sysctl net.core.somaxconn=65535 --sysctl net.ipv4.tcp_rmem="253952 253952 16777216" --sysctl net.ipv4.tcp_wmem="253952 253952 16777216" --name fastapi-py311-normal-2 --network normal_py311_default2 -p 15001:5000 -d fastapi-py311-normal-keep-alive >/dev/null 2>&1
docker run --sysctl net.core.somaxconn=65535 --sysctl net.ipv4.tcp_rmem="253952 253952 16777216" --sysctl net.ipv4.tcp_wmem="253952 253952 16777216" --name fastapi-py311-normal-3 --network normal_py311_default3 -p 15002:5000 -d fastapi-py311-normal-keep-alive-long >/dev/null 2>&1
docker run --sysctl net.core.somaxconn=65535 --sysctl net.ipv4.tcp_rmem="253952 253952 16777216" --sysctl net.ipv4.tcp_wmem="253952 253952 16777216" --name fastapi-py311-normal-4 --network normal_py311_default4 -p 15003:5000 -d fastapi-py311-normal-keep-alive-long >/dev/null 2>&1

docker run --sysctl net.core.somaxconn=65535 --name lb-1 --network normal_py311_default1 -d -v $(PWD)/reverse-proxy/nginx1.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1
docker run --sysctl net.core.somaxconn=65535 --name lb-2 --network normal_py311_default2 -d -v $(PWD)/reverse-proxy/nginx2.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1
docker run --sysctl net.core.somaxconn=65535 --name lb-3 --network normal_py311_default3 -d -v $(PWD)/reverse-proxy/nginx3.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1
docker run --sysctl net.core.somaxconn=65535 --name lb-4 --network normal_py311_default4 -d -v $(PWD)/reverse-proxy/nginx4.conf:/etc/nginx/nginx.conf nginx >/dev/null 2>&1

echo "Initial Mem Usage"
echo "=========================================="
docker stats fastapi-py311-normal-1 fastapi-py311-normal-2 fastapi-py311-normal-3 fastapi-py311-normal-4 --no-stream --format "{{.Name}}: {{.MemUsage}}"
echo "=========================================="
echo "Run bench mark with FastAPI(enable keep-alive(with lb))"
docker run --sysctl net.core.somaxconn=65535 --name case-1 --network normal_py311_default1 peterevans/vegeta sh -c "echo 'GET http://lb-1/' | vegeta attack -rate=200 -duration=120s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark with FastAPI(enable keep-alive(with lb))"
docker run --sysctl net.core.somaxconn=65535 --name case-2 --network normal_py311_default2 peterevans/vegeta sh -c "echo 'GET http://lb-2/' | vegeta attack -rate=200 -duration=120s -keepalive true -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark with FastAPI(enable keep-alive-long(with lb))"
docker run --sysctl net.core.somaxconn=65535 --name case-3 --network normal_py311_default3 peterevans/vegeta sh -c "echo 'GET http://lb-3/' | vegeta attack -rate=200 -duration=120s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark with FastAPI(enable keep-alive-long(with lb))"
docker run --sysctl net.core.somaxconn=65535 --name case-4 --network normal_py311_default4 peterevans/vegeta sh -c "echo 'GET http://lb-4/' | vegeta attack -rate=200 -duration=120s -keepalive true -max-workers=128 | tee results.bin | vegeta report"
echo "=========================================="
echo "After Requests Mem Usage"
docker stats fastapi-py311-normal-1 fastapi-py311-normal-2 fastapi-py311-normal-3 fastapi-py311-normal-4 --no-stream --format "{{.Name}}: {{.MemUsage}}"

echo "=[SUMMARY] load balancer reset ===================="
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): disabled"
docker logs lb-1 2>&1 | grep -c "reset by peer"
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): enabled"
docker logs lb-2 2>&1 | grep -c "reset by peer"
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): disabled"
docker logs lb-3 2>&1 | grep -c "reset by peer"
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): enabled"
docker logs lb-4 2>&1 | grep -c "reset by peer"
echo "=[SUMMARY] Worker process shutdown ======="
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-1 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): enabled"
docker logs fastapi-py311-normal-2 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-3 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): enabled"
docker logs fastapi-py311-normal-4 2>&1 | grep -c 'shutdown complete'

echo "=========================================="
echo "Cleanup...."
docker stop fastapi-py311-normal-1 >/dev/null 2>&1
docker stop fastapi-py311-normal-2 >/dev/null 2>&1
docker stop fastapi-py311-normal-3 >/dev/null 2>&1
docker stop fastapi-py311-normal-4 >/dev/null 2>&1
docker stop case-1 > /dev/null 2>&1
docker stop case-2 > /dev/null 2>&1
docker stop case-3 > /dev/null 2>&1
docker stop case-4 > /dev/null 2>&1

docker stop lb-1 > /dev/null 2>&1
docker stop lb-2 > /dev/null 2>&1
docker stop lb-3 > /dev/null 2>&1
docker stop lb-4 > /dev/null 2>&1
echo "=========================================="
docker network rm normal_py311_default1 normal_py311_default2 normal_py311_default3 normal_py311_default4 >/dev/null 2>&1
