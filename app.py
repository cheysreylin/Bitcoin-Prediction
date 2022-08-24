import numpy as np
from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import pandas as pd
import json

app = Flask(__name__)
CORS(app)

# model = pickle.load(open('./models/model.pkl', 'rb'))


@app.route("/", methods=['GET'])
def index():
    return "Hello World."


@app.route('/api/predict', methods=['POST'])
def predict():
    data = request.get_json()
    columns = ['Price', 'Open', 'High', 'Low']
    df = pd.DataFrame(data, index=[0], columns=columns)
    print(df)
    model = pickle.load(open('./models/model.pkl', 'rb'))
    output = model.predict(df)
    return app.response_class(
        response=json.dumps({
            "predict": output[0],
        }),
        status=200,
        mimetype='application/json'
    )


if __name__ == '__main__':
    app.run(debug=True)
