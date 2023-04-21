import multiprocessing
from flask import Flask, request, jsonify
from uuid import uuid4
import threading

host_name = "0.0.0.0"
port = 6064

app = Flask(__name__)             # create an app instance

APP_VERSION = "1.0.2"

_requests_queue: multiprocessing.Queue = None

@app.route("/data", methods=['POST'])
def data():
    content = request.json

    req_id = uuid4().__str__()

    try:
        input_data = {
            "id": req_id,
            "operation": "input_event",
            "deliver_to": "analyzer",
            "value": content['value']
            }
        _requests_queue.put(input_data)
        print(f"input_event: {input_data}")
    except:
        error_message = f"malformed request {request.data}"
        print(error_message)
        return error_message, 400
    return jsonify({"operation": "input_event", "id": req_id})

def start_rest(requests_queue):
    global _requests_queue 
    _requests_queue = requests_queue
    threading.Thread(target=lambda: app.run(host=host_name, port=port, debug=True, use_reloader=False)).start()

if __name__ == "__main__":        # on running python app.py
    start_rest(None)