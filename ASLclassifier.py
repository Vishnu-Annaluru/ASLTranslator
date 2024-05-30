import os
from flask import Flask, request, jsonify
import werkzeug
import tensorflow as tf
from tensorflow import keras
import keras
from keras.models import load_model
from PIL import Image
import numpy as np
import csv

app = Flask(__name__)

@app.route('/', methods = ['GET'])
def index():
    return jsonify({'message': 'hello'})

@app.route('/apiModel', methods = ['POST'])
def index2():
    return 'MODEL PAGE'

@app.route('/apiModel/test', methods = ['GET'])
def test():
    return 'test'

@app.route('/apiModel/get', methods = ['POST', 'GET'])
def getImgs():
    
    if(request.method == 'POST'):
        imagefile = request.files['image']
        fname = werkzeug.utils.secure_filename(imagefile.filename)
        
        print(fname)
        
        if not os.path.exists('./uploadedimages'):
            os.makedirs('./uploadedimages')
        
        imagefile.save('./uploadedimages/'+fname)
        
        

        # return jsonify({
        #     "message": model('./uploadedimages/'+fname),
        # })
        
        return model('./uploadedimages/'+fname)
        
    return "GET REQUEST MADE"

def model(imagepath):
    model = load_model("asl_model.h5")
    label_to_letter = {
        0: 'A',
        1: 'B',
        2: 'C',
        3: 'D',
        4: 'E',
        5: 'F',
        6: 'G',
        7: 'H',
        8: 'I',
        9: 'J',
        10: 'K',
        11: 'L',
        12: 'M',
        13: 'N',
        14: 'O',
        15: 'P',
        16: 'Q',
        17: 'R',
        18: 'S',
        19: 'T',
        20: 'U',
        21: 'V',
        22: 'W',
        23: 'X',
        24: 'Y',
        25: 'Z',
        26: 'del',
        27: 'nothing',
        28: 'space',
    }
    # Function to preprocess the input image
    def preprocess_image(image_path):
        img = Image.open(image_path)
        img = img.resize((224, 224))  # Resize image to match model input size
        img = np.array(img) / 255.0  # Normalize pixel values
        img = np.expand_dims(img, axis=0)  # Add batch dimension
        return img

    # Function to predict label from image
    def predict_label(image_path):
        img = preprocess_image(image_path)
        prediction = model.predict(img)
        predicted_label = np.argmax(prediction)
        return predicted_label

    # Test image file paths
    image_files = [imagepath]  # Add your test image paths here

    # Predict labels for test images
    predicted_labels = []
    for image_file in image_files:
        predicted_label = predict_label(image_file)
        predicted_labels.append(predicted_label)

    predicted_letters = [label_to_letter[label] for label in predicted_labels]
    
    
    
    

    return predicted_letters[0]

    


if __name__ == '__main__':
    print('Server is running')
    app.run(debug=True)