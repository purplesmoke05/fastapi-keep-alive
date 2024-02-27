import decimal
import logging
import threading, os
from typing import Any
from fastapi import FastAPI
import random
from fastapi.responses import ORJSONResponse
from orjson import orjson

logger = logging.getLogger("app.main")
app = FastAPI()


def decimal_default(obj):
    if isinstance(obj, decimal.Decimal):
        return float(obj)
    raise TypeError


class CustomORJSONResponse(ORJSONResponse):
    media_type = "application/json"

    def render(self, content: Any) -> bytes:
        return orjson.dumps(
            content,
            option=orjson.OPT_NON_STR_KEYS | orjson.OPT_SERIALIZE_NUMPY,
            default=decimal_default,
        )


@app.get("/")
async def root():
    a = random.randint(1, 1_000)
    data = [a] * 5_000_000

    message = f"process={os.getpid()} thread={threading.get_ident()}"
    logger.info(message)
    return CustomORJSONResponse({"message": "Hello World", "data": data})
