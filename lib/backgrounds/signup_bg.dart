import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.65,
                  child: Image.asset(
                    "assets/bg.png",
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.cover,
                  ),
                )),
            Positioned(
                top: size.height * 0.3,
                right: size.width * 0.7,
                child: Image.asset(
                  "assets/shape.png",
                  width: size.width,
                  height: size.height,
                )),
            Positioned(
                top: -size.height * 0.4,
                right: -size.width * 0.8,
                child: Image.asset(
                  "assets/shape.png",
                  width: size.width,
                  height: size.height,
                )),
            child,
          ],
        ));
  }
}
