import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: CircularProgressIndicator.adaptive(),
      )),
      backgroundColor: Color(0x59ECFF),
    );
  }
}
