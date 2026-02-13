from flask import Flask, request, jsonify

app = Flask(__name__)

# In-memory storage (hackathon friendly)
missing_persons = []

# 1️⃣ Alive check
@app.route("/check", methods=["GET"])
def home():
    
    return jsonify({
        "status": "Backend is alive",
        "message": "Missing Person AI Backend Working"
    })

# 2️⃣ Report missing person
@app.route("/report", methods=["POST"])
def report_missing():
    data = request.json

    person = {
        "name": data.get("name"),
        "age": data.get("age"),
        "image": data.get("image")  # image filename
    }

    missing_persons.append(person)

    return jsonify({
        "status": "success",
        "message": "Missing person reported successfully",
        "data": person
    })

# 3️⃣ View all missing persons
@app.route("/missing", methods=["GET"])
def get_missing():
    return jsonify({
        "count": len(missing_persons),
        "missing_persons": missing_persons
    })

# 4️⃣ CCTV / Camera check (SIMULATED AI)
@app.route("/check", methods=["POST"])
def check_camera():
    data = request.json
    camera_image = data.get("image")

    target_image = "C:/Users/Acer/OneDrive/Desktop/New folder/portrait-white-man-isolated.jpg"

    if camera_image == target_image:
        return jsonify({
            "result": "yes",
            "location": "kayamkulam,alappuzha"
        })
    else:
        return jsonify({
            "result": "no"
        })

if __name__ == "__main__":
    app.run(debug=True)