import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;

  Logo({@required this.size});

  @override
  Widget build(BuildContext context) {
    return Hero(
      child: Material(
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/logo-skinny.png',
              height: size,
            ),
            Padding(padding: EdgeInsets.all(3)),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Splits.io'.substring(1),
                    style: TextStyle(
                      fontFamily: 'Bukhari Script',
                      fontSize: size,
                    ),
                  ),
                ],
                style: TextStyle(
                    fontFamily: 'Bukhari Script Alternates', fontSize: size),
                text: 'Splits.io'[0],
              ),
            ),
          ],
        ),
        type: MaterialType.transparency,
      ),
      tag: 'logo',
    );
  }
}
