import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SynergeOpenEffect extends StatelessWidget {
  SynergeOpenEffect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ModalBarrier(),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset("assets/lotties/firecrakers.json", repeat: false)
          ],
        )),
      ],
    );
  }
}
