import 'package:flutter/material.dart';

final _themeKey = new GlobalKey(debugLabel: 'pm_theme');

class ColoredWidget extends StatefulWidget {
  final child;
  final Color defaultColor;

  ColoredWidget({this.child, this.defaultColor}) : super(key: _themeKey);

  @override
  ColoredWidgetState createState() => ColoredWidgetState(defaultColor);
}

class ColoredWidgetState extends State<ColoredWidget> {
  Color _color;

  ColoredWidgetState(Color defaultColor) {
    this._color = defaultColor;
  }

  set color(newColor) {
    setState(() => _color = newColor);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(primaryColor: _color);

    return ColorChanger(
      themeKey: _themeKey,
      child: Theme(
        data: theme,
        child: widget.child,
      ),
    );
  }
}

class ColorChanger extends InheritedWidget {
  static ColorChanger of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorChanger);
  }

  final ThemeData theme;
  final GlobalKey _themeKey;

  ColorChanger({themeKey, this.theme, child})
      : _themeKey = themeKey,
        super(child: child);

  set color(Color color) {
    (_themeKey.currentState as ColoredWidgetState)?.color = color;
  }

  @override
  bool updateShouldNotify(ColorChanger oldWidget) {
    return oldWidget.theme == theme;
  }
}

//----------------------------------------------------------------//

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
