import pickle
from flask import Flask, request, Response
from bootstrap import *

app = Flask(__name__)
filename = "status.pkl"


@app.route("/", methods=["GET", "POST"])
def handle():
    if request.method == "POST":
        status = (request.form["status"] == "on", request.form["color"])
        if status[0]:
            led.fill(color_hex(status[1]))
            led.update()
        else:
            led.all_off()

        with open(filename, "wb") as f:
            pickle.dump(status, f)
    else:
        try:
            with open(filename, "rb") as f:
                status = pickle.load(f)
        except IOError:
            with open(filename, "wb") as f:
                status = (True, "FFFFFFFF")
                pickle.dump(status, f)
    r = ("On" if status[0] else "Off") + ", #" + status[1]
    print(r)
    return Response(r, mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5555)
