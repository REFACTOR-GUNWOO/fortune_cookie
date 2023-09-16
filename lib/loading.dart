import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading {
  static DialogRoute? dialogRoute;
  static start(BuildContext dialogContext) async {
    var myDialogRoute = DialogRoute(
      context: dialogContext,
      builder: (BuildContext context) {
        return SizedBox(
            width: 50, height: 50, child: CircularProgressIndicator());
      },
    );
    dialogRoute = myDialogRoute;

    /// push the dialog route
    await Navigator.of(dialogContext).push(myDialogRoute);
  }

  static end(BuildContext context) {
    if (dialogRoute != null) {
      print("close");
      Navigator.of(context).removeRoute(dialogRoute!);
    }
  }
}
