import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class CircularTimerImage extends StatefulWidget {
  static const String path = '/CircularTimerImage';

  final double initValue = 0;
  final File image;
  final double size;

  CircularTimerImage({this.image, this.size});

  @override
  _CircularTimerImageState createState() => _CircularTimerImageState();
}

class _CircularTimerImageState extends State<CircularTimerImage> {
  double value = 0;
  double maxValue = 10;

  @override
  void initState() {
    value = widget.initValue;

    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (value < maxValue)
          value += 1 / maxValue;
        else
          timer.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment(0, 0),
        children: <Widget>[
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FileImage(widget.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 200.0,
            child: CircularProgressIndicator(value: value, strokeWidth: 7.0),
          )
        ],
      ),
    );
  }
}
