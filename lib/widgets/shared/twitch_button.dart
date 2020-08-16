import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color twitchPurple = Color(0xFF9146FF);

class TwitchButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  TwitchButton({@required this.child, this.onPressed}) : super();

  Widget build(BuildContext context) {
    return RaisedButton(
        color: twitchPurple, textColor: Colors.white, child: child, onPressed: onPressed);
  }
}
