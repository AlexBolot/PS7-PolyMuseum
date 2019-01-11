import 'package:flutter/material.dart';
import 'ColorChanger.dart';

final _themeKey = new GlobalKey(debugLabel: 'pm_theme');

class ColoredWidget extends StatefulWidget {
  final child;
  final Color defaultColor;
  
  ColoredWidget({
      this.child,
      this.defaultColor
  }) : super(key : _themeKey);

  @override
  ColoredWidgetState createState() => ColoredWidgetState(defaultColor);
}

class ColoredWidgetState extends State<ColoredWidget> {
  Color _color;

  ColoredWidgetState(Color defaultColor) {
    this._color = defaultColor;
  }

  set color(newColor) {
    if (newColor != _color) {
      setState(() => _color = newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = new ThemeData(primaryColor : _color);

    return new ColorChanger(
      themeKey : _themeKey,
      child  : new Theme(
        data : theme,
        child : widget.child,
      )
    );
  }
}

class ColorChanger extends InheritedWidget {
  static ColorChanger of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorChanger);
  }

  final ThemeData theme;
  final GlobalKey _themeKey;

  ColorChanger({
      themeKey,
      this.theme,
      child
  }) : _themeKey = themeKey, super(child : child);

  set color(Color color) {
    (_themeKey.currentState as ColoredWidgetState)?.color = color;
  }

  @override
  bool updateShouldNotify(ColorChanger oldWidget) {
    return oldWidget.theme == theme;
  }
}
