import 'package:flutter/material.dart';
import 'package:poly_museum/widget_factory/enum_factory.dart';

class WidgetFactory {
  final Map<String, dynamic> data;

  WidgetFactory(this.data);

  Widget build() => _fromName(name: data['name'], params: data['params']);

  Widget _fromName({String name, Map params}) {
    switch (name) {
      case 'Container':
        return _container(
          colorValue: params['colorValue'] ?? 0xFFFFFF,
          height: params['height'],
          width: params['width'],
          topMargin: params['topMargin'] ?? 0.0,
          rightMargin: params['rightMargin'] ?? 0.0,
          bottomMargin: params['bottomMargin'] ?? 0.0,
          leftMargin: params['leftMargin'] ?? 0.0,
          topPadding: params['topPadding'] ?? 0.0,
          rightPadding: params['rightPadding'] ?? 0.0,
          bottomPadding: params['bottomPadding'] ?? 0.0,
          leftPadding: params['leftPadding'] ?? 0.0,
          child: params['child'] != null
              ? _fromName(name: params['child']['name'], params: params['child']['params'])
              : Container(),
        );
      case 'Text':
        return _text(
          value: params['value'] ?? '',
          colorValue: params['colorValue'] ?? 0,
          fontSize: params['fontSize'] ?? 14.0,
          textAlign: params['textAlign'],
        );
      case 'Card':
        return _card(
          colorValue: params['colorValue'] ?? 0xFFFFFF,
          elevation: params['elevation'] ?? 1.0,
          topMargin: params['topMargin'] ?? 0.0,
          rightMargin: params['rightMargin'] ?? 0.0,
          bottomMargin: params['bottomMargin'] ?? 0.0,
          leftMargin: params['leftMargin'] ?? 0.0,
          child: params['child'] != null
              ? _fromName(name: params['child']['name'], params: params['child']['params'])
              : Container(),
        );
      case 'Column':
        return _column(
          mainAxisAlignment: params['mainAxisAlignment'],
          mainAxisSize: params['mainAxisSize'],
          crossAxisAlignment: params['crossAxisAlignment'],
          textDirection: params['textDirection'],
          verticalDirection: params['verticalDirection'],
          textBaseline: params['textBaseline'],
          children: _childrenFromName(params['children']),
        );
      case 'Row':
        return _row(
          mainAxisAlignment: params['mainAxisAlignment'],
          mainAxisSize: params['mainAxisSize'],
          crossAxisAlignment: params['crossAxisAlignment'],
          textDirection: params['textDirection'],
          verticalDirection: params['verticalDirection'],
          textBaseline: params['textBaseline'],
          children: _childrenFromName(params['children']),
        );
      case 'Padding':
        return _padding(
          topPadding: params['topPadding'] ?? 0.0,
          rightPadding: params['rightPadding'] ?? 0.0,
          bottomPadding: params['bottomPadding'] ?? 0.0,
          leftPadding: params['leftPadding'] ?? 0.0,
          child: params['child'] != null
              ? _fromName(name: params['child']['name'], params: params['child']['params'])
              : Container(),
        );
      case 'Image':
        return _image(
          source: params['source'] ?? 'https://bit.ly/2RXBjY1',
          height: params['height'],
          width: params['width'],
          boxFit: params['boxFit'],
        );
    }

    // Gets to this line if name is
    // null, empty or not in the switch cases
    return Container();
  }

  //region ---------- Container ----------
  Container _container({
    double topPadding,
    double rightPadding,
    double bottomPadding,
    double leftPadding,
    double topMargin,
    double rightMargin,
    double bottomMargin,
    double leftMargin,
    int colorValue,
    double height,
    double width,
    Widget child,
  }) {
    return Container(
      padding: EdgeInsets.only(top: topPadding, right: rightPadding, bottom: bottomPadding, left: leftPadding),
      margin: EdgeInsets.only(top: topMargin, right: rightMargin, bottom: bottomMargin, left: leftMargin),
      color: colorValue == null ? Colors.white : Color(colorValue).withOpacity(1.0),
      height: height,
      width: width,
      child: child,
    );
  }

  //endregion

  //region ---------- Text ---------------

  Text _text({String value, int colorValue, double fontSize, String textAlign}) {
    return Text(
      value,
      textAlign: EnumFactory.textAlign(textAlign),
      style: TextStyle(
        fontSize: fontSize,
        color: colorValue == null ? Colors.white : Color(colorValue).withOpacity(1.0),
      ),
    );
  }

  //endregion

  //region ---------- Card ---------------

  Card _card({
    int colorValue,
    double elevation,
    double topMargin,
    double rightMargin,
    double bottomMargin,
    double leftMargin,
    Widget child,
  }) {
    return Card(
      color: colorValue == null ? Colors.white : Color(colorValue).withOpacity(1.0),
      elevation: elevation,
      margin: EdgeInsets.only(top: topMargin, right: rightMargin, bottom: bottomMargin, left: leftMargin),
      child: child,
    );
  }

  //endregion

  //region ---------- Column -------------

  Column _column({
    String mainAxisAlignment,
    String mainAxisSize,
    String crossAxisAlignment,
    String textDirection,
    String verticalDirection,
    String textBaseline,
    List<Widget> children,
  }) {
    return Column(
      mainAxisAlignment: EnumFactory.mainAxisAlignment(mainAxisAlignment),
      mainAxisSize: EnumFactory.mainAxisSize(mainAxisSize),
      crossAxisAlignment: EnumFactory.crossAxisAlignment(crossAxisAlignment),
      textDirection: EnumFactory.textDirection(textDirection),
      verticalDirection: EnumFactory.verticalDirection(verticalDirection),
      textBaseline: EnumFactory.textBaseline(textBaseline),
      children: children,
    );
  }

  //endregion

  //region ---------- Row ----------------

  Row _row({
    String mainAxisAlignment,
    String mainAxisSize,
    String crossAxisAlignment,
    String textDirection,
    String verticalDirection,
    String textBaseline,
    List<Widget> children,
  }) {
    return Row(
      mainAxisAlignment: EnumFactory.mainAxisAlignment(mainAxisAlignment),
      mainAxisSize: EnumFactory.mainAxisSize(mainAxisSize),
      crossAxisAlignment: EnumFactory.crossAxisAlignment(crossAxisAlignment),
      textDirection: EnumFactory.textDirection(textDirection),
      verticalDirection: EnumFactory.verticalDirection(verticalDirection),
      textBaseline: EnumFactory.textBaseline(textBaseline),
      children: children,
    );
  }

  //endregion

  //region ---------- Padding ------------

  Padding _padding({
    double topPadding,
    double rightPadding,
    double bottomPadding,
    double leftPadding,
    Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, right: rightPadding, bottom: bottomPadding, left: leftPadding),
      child: child,
    );
  }

  //endregion

  //region ---------- Image --------------

  Image _image({String source, double height, double width, String boxFit}) {
    return Image.network(source, height: height, width: width, fit: EnumFactory.boxFit(boxFit));
  }

  //endregion

  List<Widget> _childrenFromName(List<Map> children) {
    return children.map((child) => _fromName(name: child['name'], params: child['params'])).toList();
  }
}
