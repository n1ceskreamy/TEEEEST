#!/usr/bin/env python

import time
import threading
import requests
import json
from random import randrange

CONTENT_HEADER = {"Content-Type": "application/json"}
DELIVERY_INTERVAL_SEC = 0.5
SIGNAL_RANGE = 20


def start_pushing():
    while True:
        time.sleep(DELIVERY_INTERVAL_SEC)

        gager = randrange(SIGNAL_RANGE)
        if randrange(100) < 50:
            gager = 2500
        data = {"value": gager}
        try:
            response = requests.post(
                "http://0.0.0.0:6064/data",
                data=json.dumps(data),
                headers=CONTENT_HEADER,
            )
            print(f"[info] результат отправки данных: {response}")
        except Exception as e:
            print(f"[error] ошибка отправки данных: {e}")


if __name__ == "__main__":
    start_pushing()
