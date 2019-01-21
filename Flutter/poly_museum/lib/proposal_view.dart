import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
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
  double teamBonus = 0;
  bool loadingImage = false;
  double maxValue = 10;

  bool sendingAllowed = false;
  bool requiresCancel = false;

  Map<String, bool> teammatesNames = {};

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex : 10,
                        child: RaisedButton(
                          elevation: sendingAllowed ? 4.0 : 0.0,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Faire valider', textAlign: TextAlign.center),
                          color: sendingAllowed ? Colors.green : Colors.grey[300],
                          onPressed: () {
                            sendingAllowed ? print('Valider') : print('Woah there not so fast');
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex : 10,
                        child: RaisedButton(
                          elevation: 4.0,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Annuler'),
                          color: Colors.redAccent,
                          onPressed: () => print('Annuler'),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: teammatesNames.length,
                  itemBuilder: (context, i) {
                    String key = teammatesNames.keys.toList()[i];

                    bool reply = teammatesNames[key];
                    bool hasReply = reply != null;

                    Icon thumbDown = Icon(Icons.thumb_down, color: Colors.red);
                    Icon thumbUp = Icon(Icons.thumb_up, color: Colors.green);

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text(key, textAlign: TextAlign.center)),
                            Expanded(child: hasReply ? (reply ? thumbUp : thumbDown) : Container()),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: () async {
          teammatesNames.updateAll((key, old) => null);
          value = 0;
          teamBonus = 0;
          picture = null;
          sendingAllowed = false;
          scanImage();
        },
      ),
    );
  }

  Future loadImage(String code) async {
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
        child: CircularProgressIndicator(strokeWidth: 7.0),
      );
    }

    if (picture == null) {
      return Container(width: size, height: size);
    }

    return Container(
      child: Stack(
        alignment: Alignment(0, 0),
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FileImage(picture),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            child: CircularProgressIndicator(value: (value + teamBonus), strokeWidth: 7.0),
          )
        ],
      ),
    );
  }

  Future scanImage() async {
    // Trigger camera view for scan
    String barcode = await BarcodeScanner.scan();

    // Load the image of the item from firebase
    await loadImage(barcode);

    // Read teammates names
    List<String> listNames = await ServiceProvider.gameService.getTeammates(globalUserGroup);

    listNames.forEach((name) => teammatesNames.putIfAbsent(name, () => null));

    await ServiceProvider.gameService.addTimerObject(globalUserGroup, barcode);

    ServiceProvider.gameService.listenTimerObjectReply(globalUserGroup, (values) {
      setState(() {
        teammatesNames = values;
        int negCount = teammatesNames.values.where((item) => item != null && item == false).length;
        int posCount = teammatesNames.values.where((item) => item != null && item == true).length;
        teamBonus = (posCount * 5.0 / maxValue);
        print('$teamBonus');
        requiresCancel = (negCount > teammatesNames.length / 2);
      });
    });

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        if (value < 1)
          value += 1 / (maxValue * 100);
        else {
          timer.cancel();
          sendingAllowed = true;
        }
      });
    });

    setState(() {});
  }
}
