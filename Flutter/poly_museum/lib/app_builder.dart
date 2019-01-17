import 'package:flutter/material.dart';

class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;
  final AppBuilderState state = AppBuilderState();

  AppBuilder({@required this.builder});

  @override
  AppBuilderState createState() => state;

  static AppBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
  }
}

class AppBuilderState extends State<AppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}
