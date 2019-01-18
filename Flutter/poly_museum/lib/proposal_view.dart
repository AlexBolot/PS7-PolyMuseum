import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poly_museum/circular_timer_image.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/services/service_provider.dart';

class ProposalView extends StatefulWidget {
  static const String path = '/ProposalView';

  @override
  _ProposalViewState createState() => _ProposalViewState();
}

class _ProposalViewState extends State<ProposalView> {
  File picture;
  double value = 0;
  bool loadingImage = false;
  bool teammatesLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Value')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black38,
        child: Center(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: displayImage(),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('Envoyer à mon équipe', textAlign: TextAlign.center),
                        color: Colors.green,
                        onPressed: () => print('Valider'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('Annuler'),
                        color: Colors.redAccent,
                        onPressed: () => print('Annuler'),
                      ),
                    ),
                  ],
                ),
                displayTeammates(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: () async {
          picture = null;
          String barcode = await BarcodeScanner.scan();
          loadImage(barcode);
          loadTeammates();
          setState(() => loadingImage = true);
        },
      ),
    );
  }

  void loadTeammates() async {
    await ServiceProvider.gameService.getTeammates(globalUserGroup);
    setState(() {
      teammatesLoaded = true;
    });
  }

  void loadImage(String code) async {
    File file = await ServiceProvider.gameService.getImageFromCode(code);
    setState(() {
      picture = file;
      loadingImage = false;
    });
  }

  Widget displayImage() {
    double size = 200.0;

    if (picture == null && loadingImage) {
      return Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(strokeWidth: 6.0),
      );
    }

    if (picture == null) {
      return Container(
        width: size,
        height: size,
      );
    }

    var timerImage = CircularTimerImage(image: picture, size: size);
    timerImage.createState();
    return timerImage;
  }

  Widget displayTeammates() {
    List<DocumentReference> teammates = ServiceProvider.gameService.teammates;

    if (teammatesLoaded) {
      return ListView.builder(
        itemBuilder: (context, i) {
          return Card(child: Text(teammates[i].documentID));
        },
        itemCount: teammates.length,
        shrinkWrap: true,
      );
    }
    else
      return Container();
  }
}
