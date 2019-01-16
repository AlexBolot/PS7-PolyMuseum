import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poly_museum/ColorChanger.dart';

String currentGroupID = "1";
String globalBarcode = "";
String globalUserGroup = "1";
String globalUserTeam = "1";
String globalUserName = "Paul";

ThemeData globalTheme = ThemeData();
AppBuilder appBuilder;

DocumentReference museumReference = Firestore.instance.collection("Musées").document("NiceSport");

DocumentReference changeMuseumTarget(String museumName) {
  museumReference = Firestore.instance.collection("Musées").document(museumName);
  return museumReference;
}
