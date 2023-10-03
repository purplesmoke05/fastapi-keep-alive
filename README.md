# Fastapi Connectivity test

This is a simple test for connectivity between fastapi and client via lb(nginx).

## Usage

1. Install Docker
2. run `bash test_lb.sh`

## Summary

```
Start Server....
Initial Mem Usage
==========================================
fastapi-py311-normal-1: 137.8MiB / 11.68GiB
fastapi-py311-normal-2: 137.9MiB / 11.68GiB
fastapi-py311-normal-3: 137.9MiB / 11.68GiB
fastapi-py311-normal-4: 137.9MiB / 11.68GiB
==========================================
Run bench mark with FastAPI(enable keep-alive(with lb))
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Requests      [total, rate, throughput]         24000, 200.01, 199.97
Duration      [total, attack, wait]             2m0s, 2m0s, 1.299ms
Latencies     [min, mean, 50, 90, 95, 99, max]  780µs, 4.172ms, 1.235ms, 1.783ms, 3.53ms, 109.658ms, 309.757ms
Bytes In      [total, mean]                     600528, 25.02
Bytes Out     [total, mean]                     0, 0.00
Success       [ratio]                           99.98%
Status Codes  [code:count]                      200:23996  502:4
Error Set:
502 Bad Gateway
==========================================
Run bench mark with FastAPI(enable keep-alive(with lb))
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Requests      [total, rate, throughput]         24000, 200.01, 199.95
Duration      [total, attack, wait]             2m0s, 2m0s, 1.201ms
Latencies     [min, mean, 50, 90, 95, 99, max]  494µs, 5.041ms, 1.217ms, 1.771ms, 3.742ms, 138.229ms, 441.645ms
Bytes In      [total, mean]                     600924, 25.04
Bytes Out     [total, mean]                     0, 0.00
Success       [ratio]                           99.97%
Status Codes  [code:count]                      200:23993  502:7
Error Set:
502 Bad Gateway
==========================================
Run bench mark with FastAPI(enable keep-alive-long(with lb))
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Requests      [total, rate, throughput]         24000, 200.01, 199.97
Duration      [total, attack, wait]             2m0s, 2m0s, 1.594ms
Latencies     [min, mean, 50, 90, 95, 99, max]  636µs, 3.705ms, 1.22ms, 1.708ms, 2.892ms, 101.896ms, 247.966ms
Bytes In      [total, mean]                     600660, 25.03
Bytes Out     [total, mean]                     0, 0.00
Success       [ratio]                           99.98%
Status Codes  [code:count]                      200:23995  502:5
Error Set:
502 Bad Gateway
==========================================
Run bench mark with FastAPI(enable keep-alive-long(with lb))
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Requests      [total, rate, throughput]         24000, 200.01, 199.96
Duration      [total, attack, wait]             2m0s, 2m0s, 1.197ms
Latencies     [min, mean, 50, 90, 95, 99, max]  578µs, 4.367ms, 1.232ms, 1.795ms, 3.874ms, 110.816ms, 325.742ms
Bytes In      [total, mean]                     600660, 25.03
Bytes Out     [total, mean]                     0, 0.00
Success       [ratio]                           99.98%
Status Codes  [code:count]                      200:23995  502:5
Error Set:
502 Bad Gateway
==========================================
After Requests Mem Usage
fastapi-py311-normal-1: 140.1MiB / 11.68GiB
fastapi-py311-normal-2: 141.5MiB / 11.68GiB
fastapi-py311-normal-3: 138.9MiB / 11.68GiB
fastapi-py311-normal-4: 142.9MiB / 11.68GiB
=[SUMMARY] load balancer reset ====================
keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): disabled
4
keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): enabled
7
keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): disabled
5
keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): enabled
5
=[SUMMARY] Worker process shutdown =======
keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): disabled
372
keepalive(server): enabled, keepalive(lb): enabled, keepalive(client): enabled
364
keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): disabled
367
keepalive(server): enabled(long), keepalive(lb): enabled, keepalive(client): enabled
365
==========================================
Cleanup....
==========================================
```
