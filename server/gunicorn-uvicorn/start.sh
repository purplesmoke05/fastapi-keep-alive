#!/bin/bash
source ~/.bash_profile


# gunicorn parameters
WORKER_COUNT=${WORKER_COUNT:-4}
WORKER_TIMEOUT=${WORKER_TIMEOUT:-30}
WORKER_MAX_REQUESTS=${WORKER_MAX_REQUESTS:-2000}
WORKER_MAX_REQUESTS_JITTER=${WORKER_MAX_REQUESTS_JITTER:-500}
KEEP_ALIVE=${KEEP_ALIVE:-2}

gunicorn --worker-class server.AppUvicornWorker \
         --workers ${WORKER_COUNT} \
         --bind 0.0.0.0:5000 \
         --timeout ${WORKER_TIMEOUT} \
         --max-requests ${WORKER_MAX_REQUESTS} \
         --max-requests-jitter ${WORKER_MAX_REQUESTS_JITTER} \
         --keep-alive ${KEEP_ALIVE} \
         test.main:app
