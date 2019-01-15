import os
import json
import firebase_admin
from flask import Flask
from flask import request
from flask_api import status

from firebase_admin import credentials, firestore, storage

from config import *

cred = credentials.Certificate(certificate_path);
firebase_admin.initialize_app(cred, {
    'project_id' : 'polymuseum-ps7',
    'storageBucket' : 'polymuseum-ps7.appspot.com'
})

db = firestore.client()

def write_data(key, value, target):
    print(key + " : " + str(value) + "(" + target + ")")

    tokens = target.split('/')
    ref = db.collection(tokens[1])
    
    document = True
    for level in target.split('/')[2:]:
        if document:
            ref = ref.document(level)
            print('document ' + level)
        else:
            ref = ref.collection(level)
            print('collection ' + level)
        
        document = not document

    ref.set({key : value}, merge=True);

def upload_recurs(tree, target):
    for key, value in tree.items():
        if type(value) is dict:
            upload_recurs(value, target + "/" + key)
        else:
            write_data(key, value, target)
        
def upload_config(filepath):
    with open(filepath) as f:
        data = json.load(f)
    
    target = data['target']
    
    upload_recurs(data['data'], target)
    
#
        
app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload():
    f = request.files['config-file']
    f.save('./uploads/' + f.filename)
    upload_config('./uploads/' + f.filename)    

    
    return 'Sucess', status.HTTP_200_OK

if __name__ == '__main__':
    app.run()
