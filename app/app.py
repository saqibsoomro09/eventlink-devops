from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/")
def index():
    return """
    <h2> EventLink is alive</h2>
    <p>Endpoints:</p>
    <ul>
      <li><a href="/health">/health</a></li>
      <li><a href="/add?a=6&b=9">/add?a=6&b=9</a></li>
      <li><a href="/subtract?a=10&b=4">/subtract?a=10&b=4</a></li> 
      <li><a href="/multiply?a=3&b=4">/multiply?a=3&b=4</a></li>

    </ul>
    """, 200


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
    

@app.get("/multiply")
def multiply():
    try:
        a = float(request.args.get("a", 0)); b = float(request.args.get("b", 0))
        return jsonify({"result": a * b})
    except Exception as e:
        app.logger.error("multiply failed: %s", e)
        return jsonify({"error": "bad inputs"}), 400  
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
