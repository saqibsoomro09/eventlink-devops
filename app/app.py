# app/app.py
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/")
def index():
    # Simple landing page for quick browser checks
    return "EventLink is alive", 200

@app.get("/health")
def health():
    # Readiness for CodeDeploy ValidateService
    return jsonify(status="ok"), 200

@app.route("/add", methods=["GET", "POST"])
def add():
    """
    Accepts:
      - GET:  /add?a=2&b=3
      - POST: JSON {"a": 2, "b": 3}
    Returns:
      - JSON {"result": 5.0}
    """
    if request.method == "GET":
        a = request.args.get("a", "0")
        b = request.args.get("b", "0")
    else:
        data = request.get_json(silent=True) or {}
        a = data.get("a", 0)
        b = data.get("b", 0)

    try:
        a = float(a)
        b = float(b)
    except (TypeError, ValueError):
        return jsonify(error="Inputs must be numbers"), 400

    return jsonify(result=a + b), 200


# NOTE: Level 4 evolution – we can add /subtract later to trigger auto-deploy.

if __name__ == "__main__":
    # Local dev only; on EC2 we run via systemd+gunicorn on :80
    app.run(host="0.0.0.0", port=8080, debug=False)
