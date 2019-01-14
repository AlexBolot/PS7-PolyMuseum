import json
import firebase_admin
from firebase_admin import credentials, firestore, storage

import os



cred = credentials.Certificate('/home/basil/Projets/PS7/polymuseum-ps7-firebase-adminsdk-0gks3-473facb980.json');
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
    

upload_config('/home/basil/Projets/PS7/config-color.json')
        

