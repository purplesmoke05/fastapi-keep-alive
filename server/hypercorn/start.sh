#!/bin/bash
source ~/.bash_profile


# uvicorn parameters
WORKER_COUNT=${WORKER_COUNT:-4}
KEEP_ALIVE=${KEEP_ALIVE:-2}

hypercorn --bind '0.0.0.0:5000' \
          -k uvloop \
          --log-file '-' \
          --access-logfile '-' \
          --workers ${WORKER_COUNT} \
          --keep-alive ${KEEP_ALIVE} test.main:app
