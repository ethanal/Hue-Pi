from flask import Flask, request
import pickle

app = Flask(__name__)


@app.route("/", methods=["GET", "POST"])
def handle():
    if request.method == "POST":
        return "POST"
    else:
        return "GET"

if __name__ == "__main__":
    app.run()
