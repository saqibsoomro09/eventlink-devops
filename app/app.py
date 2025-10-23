from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/version")
def version():
    return jsonify(version="1.1.0", message="EventLink is alive"), 200


@app.get("/health")
def health():
    return jsonify(status="ok"), 200

@app.route("/add", methods=["GET", "POST"])
def add():
    if request.method == "GET":
        a = request.args.get("a", "0")
        b = request.args.get("b", "0")
    else:
        data = request.get_json(silent=True) or {}
        a = data.get("a", 0)
        b = data.get("b", 0)
    try:
        a = float(a); b = float(b)
    except (TypeError, ValueError):
        return jsonify(error="Inputs must be numbers"), 400
    return jsonify(result=a + b), 200
@app.route("/subtract")
def subtract():
    try:
        a = float(request.args.get("a", 0))
        b = float(request.args.get("b", 0))
        return jsonify({"result": a - b})
    except Exception as e:
        app.logger.error("subtract failed: %s", e)
        return jsonify({"error": "bad inputs"}), 400
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
