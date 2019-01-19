import 'package:flutter/material.dart';

class EnumFactory {
  /// Returns a MainAxisAlignment enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * end
  /// * start (default)
  /// * center
  /// * spaceAround
  /// * spaceEvenly
  /// * spaceBetween
  static MainAxisAlignment mainAxisAlignment(String name) {
    switch (name) {
      case 'end':
        return MainAxisAlignment.end;
      case 'start':
        return MainAxisAlignment.start;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      default:
        return MainAxisAlignment.start;
    }
  }

  /// Returns a MainAxisSize enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * min (default)
  /// * max
  static MainAxisSize mainAxisSize(String name) {
    switch (name) {
      case 'min':
        return MainAxisSize.min;
      case 'max':
        return MainAxisSize.max;
      default:
        return MainAxisSize.min;
    }
  }

  /// Returns a CrossAxisAlignment enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * end
  /// * start
  /// * center (default)
  /// * stretch
  /// * baseline
  static CrossAxisAlignment crossAxisAlignment(String name) {
    switch (name) {
      case 'end':
        return CrossAxisAlignment.end;
      case 'start':
        return CrossAxisAlignment.start;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.center;
    }
  }

  /// Returns a TextDirection enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * ltr (default)
  /// * rtl
  static TextDirection textDirection(String name) {
    switch (name) {
      case 'ltr':
        return TextDirection.ltr;
      case 'rtl':
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }

  /// Returns a VerticalDirection enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * up
  /// * down (default)
  static VerticalDirection verticalDirection(String name) {
    switch (name) {
      case 'up':
        return VerticalDirection.up;
      case 'down':
        return VerticalDirection.down;
      default:
        return VerticalDirection.down;
    }
  }

  /// Returns a TextBaseline enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * alphabetic (default)
  /// * ideographic
  static TextBaseline textBaseline(String name) {
    switch (name) {
      case 'ideographic':
        return TextBaseline.ideographic;
      case 'alphabetic':
        return TextBaseline.alphabetic;
      default:
        return TextBaseline.alphabetic;
    }
  }

  /// Returns a TextAlign enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * end
  /// * left
  /// * right
  /// * start
  /// * center (default)
  /// * justify
  static TextAlign textAlign(String name) {
    switch (name) {
      case 'end':
        return TextAlign.end;
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'start':
        return TextAlign.start;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.start;
    }
  }

  /// Returns a BoxFit enum value corresponding the given [name]
  ///
  /// Allowed values are :
  ///
  /// * fill
  /// * none
  /// * cover
  /// * contain (default)
  /// * fitWidth
  /// * fitHeight
  /// * scaleDown
  static BoxFit boxFit(String name) {
    switch (name) {
      case 'fill':
        return BoxFit.fill;
      case 'none':
        return BoxFit.none;
      case 'cover':
        return BoxFit.cover;
      case 'contain':
        return BoxFit.contain;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.contain;
    }
  }
}
