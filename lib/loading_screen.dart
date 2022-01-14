import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
          ),
          Container(
              child: SpinKitThreeInOut(
            color: Colors.white,
            size: 50.0,
          )),
        ],
      ),
      backgroundColor: Color(0x59ECFF),
    );
  }
}
