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
bucket = storage.bucket()

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
        
def upload_config(filepath, musee, plugin):
    with open(filepath) as f:
        data = json.load(f)

    target = "/Musées/" + musee + "/plugins/" + plugin + '/config/current';
    
    upload_recurs(data['data'], target)

############

def upload_plugin(filepath, filename, config, libelle, pluginName, qualifiedName, pluginType):
    blob = bucket.blob('Plugins/' + filename)
    
    with open(filepath, 'rb') as f:
        blob.upload_from_file(f)
    
    ref = db.collection('Plugins').document(libelle)
    ref.set({ 'config' : config,
              'downloadURL' : blob._get_download_url(),
              'libelle' : libelle,
              'pluginName' : pluginName,
              'qualifiedName' : qualifiedName,
              'pluginType' : pluginType })
        
app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload_config_route():
    f = request.files['config-file']
    f.save('./uploads/' + f.filename)
    musee = request.args['musee']
    plugin = request.args['plugin']
    upload_config('./uploads/' + f.filename, musee, plugin)

    return 'Sucess', status.HTTP_200_OK

@app.route('/upload-plugin', methods=['POST'])
def upload_plugin_route():
    f = request.files['config-file']

    require_config = True if (request.form['plugin-require-config'] == 'Oui') else False
    libelle = request.form['plugin-libelle']
    qualifiedName = request.form['plugin-qualified-name']
    pluginType = request.form['plugin-type']
    pluginName = request.files['config-file'].filename
    
    f.save('./uploads/' + f.filename)
    upload_plugin('./uploads/' + f.filename, f.filename, require_config, libelle, pluginName, qualifiedName, pluginType)

    return 'Sucess', status.HTTP_200_OK

if __name__ == '__main__':
    app.run()
