from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify(status="ok"), 200

@app.post("/add")
def add():
    data = request.get_json(force=True) or {}
    a = float(data.get("a", 0))
    b = float(data.get("b", 0))
    return jsonify(result=a + b), 200

# Level 4 evolution endpoint (brief): keep simple to prove auto-deploy path
@app.post("/subtract")
def subtract():
    data = request.get_json(force=True) or {}
    a = float(data.get("a", 0))
    b = float(data.get("b", 0))
    return jsonify(result=a - b), 200

if __name__ == "__main__":
    # lab-friendly: listen on 0.0.0.0 so CodeDeploy/systemd can reach it locally
    app.run(host="0.0.0.0", port=80)
