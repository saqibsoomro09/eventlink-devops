from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/health")
def health():
    # readiness for CodeDeploy ValidateService
    return jsonify(status="ok"), 200

@app.route("/add", methods=["GET", "POST"])
def add():
    # Accept GET ?a=..&b=.. for quick demos and POST JSON for CI smoke tests
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

# NOTE: Level 4 evolution – /subtract will be added later to prove auto-deploy path.

if __name__ == "__main__":
    # Local dev only: run on 8080; in EC2 we run via systemd+gunicorn on :80
    app.run(host="0.0.0.0", port=8080, debug=False)
