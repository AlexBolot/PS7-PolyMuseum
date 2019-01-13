var config = {
    apiKey: "AIzaSyDVvoWIouSQOVUq-ZUbQmUKVwzzoxem6Bg",
    authDomain: "polymuseum-ps7.firebaseapp.com",
    databaseURL: "https://polymuseum-ps7.firebaseio.com",
    projectId: "polymuseum-ps7",
    storageBucket: "polymuseum-ps7.appspot.com",
    messagingSenderId: "400300334018"
};

// Initialize Firebase
firebase.initializeApp(config);
firebase.firestore().settings({
    timestampsInSnapshots: true
});

