import 'package:flutter/material.dart';
import 'responsive_widget.dart';

TextStyle basicButtonStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

TextStyle basicButtonStyleBig = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

TextStyle titleTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: ResponsiveWidget.isSmallScreen(context) ? 20 : 24,
  );
}
