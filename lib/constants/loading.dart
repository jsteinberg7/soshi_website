import 'package:flutter/material.dart';
import 'package:soshi/constants/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// class LoadingIconToBeUsed extends StatelessWidget {
//   @override
//   Widget build(BuildContext contxt) {
//     return SpinKitFoldingCube(size: 50);
//   }
// }

class DialogBuilder {
  DialogBuilder(this.context);

  BuildContext context;

  void showLoadingIndicator([String? text]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        this.context = c;
        return CircularProgressIndicator.adaptive();
      },
    );
  }

  void hideOpenDialog() {
    Navigator.pop(context);
  }
}

class OnboardingLoader {
  static void showLoadingIndicator(String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return SpinKitChasingDots(color: Colors.cyan, size: 50);
        return Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  static killLoader(BuildContext context) {
    Navigator.pop(context);
  }
}


// class LoadingIndicator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SpinKitCubeGrid(color: Colors.white, size: 50);
//   }
// }
