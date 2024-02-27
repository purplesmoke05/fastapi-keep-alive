#!/bin/bash
source ~/.bash_profile


# uvicorn parameters
WORKER_COUNT=${WORKER_COUNT:-4}
KEEP_ALIVE=${KEEP_ALIVE:-2}

uvicorn --host 0.0.0.0 --port 5000 \
        --workers ${WORKER_COUNT} \
        --limit-max-requests ${WORKER_MAX_REQUESTS} \
        --timeout-keep-alive ${KEEP_ALIVE} test.main:app
