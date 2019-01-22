import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poly_museum/app_builder.dart';

String currentGroupID = "1";
String globalBarcode = "";
String globalUserGroup = "1";

//WARNING : Bien match le userName et le userID QUI CORRESPONDENT dans la BD
// POUR LES ID :

//Equipe 0
// Pierre : 1 , Marie : 2 , Natasha : 4

//Equipe 1
// Marc : 3

String globalUserTeam = "0";

String globalUserID = "1";
String globalUserName = "Pierre";

ThemeData globalTheme = ThemeData();
AppBuilder appBuilder;

DocumentReference museumReference = Firestore.instance.collection("Musées").document("NiceSport");

DocumentReference changeMuseumTarget(String museumName) {
  museumReference = Firestore.instance.collection("Musées").document(museumName);
  return museumReference;
}
