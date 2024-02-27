import os
from uvicorn.workers import UvicornWorker

# uvicorn parameters
WORKER_CONNECTIONS = int(os.environ.get('WORKER_CONNECTIONS')) \
    if os.environ.get('WORKER_CONNECTIONS') else 100
KEEP_ALIVE = int(os.environ.get('KEEP_ALIVE')) \
    if os.environ.get('KEEP_ALIVE') else 2


# Worker class to load by gunicorn when server run
class AppUvicornWorker(UvicornWorker):
    CONFIG_KWARGS = {
        "loop": "asyncio",
        "http": "h11",
        # NOTE: gunicorn don't support '--worker-connections' to uvicorn
        "limit_concurrency": WORKER_CONNECTIONS,
        "timeout_keep_alive": KEEP_ALIVE,
    }
