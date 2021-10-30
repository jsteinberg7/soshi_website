import 'package:flutter/material.dart';

class Constants {
  static TextStyle CustomCyan = new TextStyle(
      color: Colors.cyan[300],
      fontSize: 15,
      letterSpacing: 2,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);

  static ThemeData CustomTheme = new ThemeData(
    primaryColor: Colors.grey[800],
    accentColor: Colors.cyan[300],
  );

  static TextStyle textStyle = new TextStyle(fontFamily: "Montserrat");

  static var backgroundColor = Colors.grey[800];

  static var buttonColorLight = Colors.grey[700];

  static var buttonColorDark = Colors.grey[850];

  static ButtonStyle ButtonStyleDark = ElevatedButton.styleFrom(
      primary: Constants.buttonColorDark,
      shadowColor: Constants.buttonColorDark,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))));

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static LinearGradient greyCyanGradient = new LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Colors.grey[800]!, Colors.cyan[300]!]);
}
