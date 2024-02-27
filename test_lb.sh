#!/bin/bash

echo "Initial Mem Usage"
echo "=========================================="
docker stats fastapi-py311-normal-1 fastapi-py311-normal-2 fastapi-py311-normal-3 fastapi-py311-normal-4 fastapi-py311-normal-5 fastapi-py311-normal-6 fastapi-py311-normal-7 fastapi-py311-normal-8 fastapi-py311-normal-9 fastapi-py311-normal-10 --no-stream --format "{{.Name}}: {{.MemUsage}}"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): disabled"
docker run --sysctl net.core.somaxconn=65535 --name case-1 --network normal_py311_default1 peterevans/vegeta sh -c "echo 'GET http://lb-1/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): enabled"
docker run --sysctl net.core.somaxconn=65535 --name case-2 --network normal_py311_default2 peterevans/vegeta sh -c "echo 'GET http://lb-2/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): disabled"
docker run --sysctl net.core.somaxconn=65535 --name case-3 --network normal_py311_default3 peterevans/vegeta sh -c "echo 'GET http://lb-3/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): enabled"
docker run --sysctl net.core.somaxconn=65535 --name case-4 --network normal_py311_default4 peterevans/vegeta sh -c "echo 'GET http://lb-4/' | vegeta attack -rate=20 -duration=30s -keepalive true -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): disabled, keepalive(lb): enabled, keepalive(client): disabled"
docker run --sysctl net.core.somaxconn=65535 --name case-5 --network normal_py311_default5 peterevans/vegeta sh -c "echo 'GET http://lb-5/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): disabled, keepalive(lb): enabled, keepalive(client): enabled"
docker run --sysctl net.core.somaxconn=65535 --name case-6 --network normal_py311_default6 peterevans/vegeta sh -c "echo 'GET http://lb-6/' | vegeta attack -rate=20 -duration=30s -keepalive true -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): disabled, keepalive(lb): disabled, keepalive(client): disabled"
docker run --sysctl net.core.somaxconn=65535 --name case-7 --network normal_py311_default7 peterevans/vegeta sh -c "echo 'GET http://lb-7/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): disabled, keepalive(lb): disabled, keepalive(client): disabled"
docker run --sysctl net.core.somaxconn=65535 --name case-8 --network normal_py311_default8 peterevans/vegeta sh -c "echo 'GET http://lb-8/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): disabled, keepalive(client): disabled"
docker run --sysctl net.core.somaxconn=65535 --name case-9 --network normal_py311_default9 peterevans/vegeta sh -c "echo 'GET http://fastapi-py311-normal-9:5000/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "Run bench mark"
echo "keepalive(server): disabled, keepalive(client): disabled"
docker run --sysctl net.core.somaxconn=65535 --name case-10 --network normal_py311_default10 peterevans/vegeta sh -c "echo 'GET http://fastapi-py311-normal-10:5000/' | vegeta attack -rate=20 -duration=30s -keepalive false -max-workers=128 | tee results.bin | vegeta report"
sleep 3
echo "=========================================="
echo "After Requests Mem Usage"
docker stats fastapi-py311-normal-1 fastapi-py311-normal-2 fastapi-py311-normal-3 fastapi-py311-normal-4 fastapi-py311-normal-5 fastapi-py311-normal-6 fastapi-py311-normal-7 fastapi-py311-normal-8 fastapi-py311-normal-9 fastapi-py311-normal-10 --no-stream --format "{{.Name}}: {{.MemUsage}}"

echo "=[SUMMARY] load balancer reset ===================="
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): disabled"
docker logs lb-1 2>&1 | grep -c "error"
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): enabled"
docker logs lb-2 2>&1 | grep -c "error"
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): disabled"
docker logs lb-3 2>&1 | grep -c "error"
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): enabled"
docker logs lb-4 2>&1 | grep -c "error"
echo "keepalive(server): disabled, keepalive(lb): enabled, keepalive(client): disabled"
docker logs lb-5 2>&1 | grep -c "error"
echo "keepalive(server): disabled, keepalive(lb): enabled, keepalive(client): enabled"
docker logs lb-6 2>&1 | grep -c "error"
echo "keepalive(server): disabled, keepalive(lb): disabled, keepalive(client): disabled"
docker logs lb-7 2>&1 | grep -c "error"
echo "keepalive(server): disabled, keepalive(lb): disabled, keepalive(client): enabled"
docker logs lb-8 2>&1 | grep -c "error"
echo "keepalive(server): disabled, keepalive(client): disabled"
docker logs lb-9 2>&1 | grep -c "error"
echo "keepalive(server): disabled, keepalive(client): disabled"
docker logs lb-10 2>&1 | grep -c "error"
echo "=[SUMMARY] Worker process shutdown ======="
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-1 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): enabled"
docker logs fastapi-py311-normal-2 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-3 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): enabled"
docker logs fastapi-py311-normal-4 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): disabled, keepalive(lb): enabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-5 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): disabled, keepalive(lb): enabled, keepalive(client): enabled"
docker logs fastapi-py311-normal-6 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): disabled, keepalive(lb): disabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-7 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): disabled, keepalive(lb): disabled, keepalive(client): enabled"
docker logs fastapi-py311-normal-8 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): disabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-9 2>&1 | grep -c 'shutdown complete'
echo "keepalive(server): disabled, keepalive(client): disabled"
docker logs fastapi-py311-normal-10 2>&1 | grep -c 'shutdown complete'
echo "=========================================="
echo "Cleanup...."
docker stop fastapi-py311-normal-1 >/dev/null 2>&1
docker stop fastapi-py311-normal-2 >/dev/null 2>&1
docker stop fastapi-py311-normal-3 >/dev/null 2>&1
docker stop fastapi-py311-normal-4 >/dev/null 2>&1
docker stop fastapi-py311-normal-5 >/dev/null 2>&1
docker stop fastapi-py311-normal-6 >/dev/null 2>&1
docker stop fastapi-py311-normal-7 >/dev/null 2>&1
docker stop fastapi-py311-normal-8 >/dev/null 2>&1
docker stop fastapi-py311-normal-9 >/dev/null 2>&1
docker stop fastapi-py311-normal-10 >/dev/null 2>&1
docker stop case-1 > /dev/null 2>&1
docker stop case-2 > /dev/null 2>&1
docker stop case-3 > /dev/null 2>&1
docker stop case-4 > /dev/null 2>&1
docker stop case-5 > /dev/null 2>&1
docker stop case-6 > /dev/null 2>&1
docker stop case-7 > /dev/null 2>&1
docker stop case-8 > /dev/null 2>&1
docker stop case-9 > /dev/null 2>&1
docker stop case-10 > /dev/null 2>&1

docker stop lb-1 > /dev/null 2>&1
docker stop lb-2 > /dev/null 2>&1
docker stop lb-3 > /dev/null 2>&1
docker stop lb-4 > /dev/null 2>&1
docker stop lb-5 > /dev/null 2>&1
docker stop lb-6 > /dev/null 2>&1
docker stop lb-7 > /dev/null 2>&1
docker stop lb-8 > /dev/null 2>&1
echo "=========================================="

