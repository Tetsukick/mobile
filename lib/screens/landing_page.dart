import 'package:flutter/material.dart';
import 'package:splitsio/models/auth.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/demo_sign_in.dart';
import 'package:splitsio/screens/index.dart';
import 'package:splitsio/widgets/shared/logo.dart';
import 'package:splitsio/widgets/shared/twitch_button.dart';

class LandingPage extends StatelessWidget {
  final String message;
  LandingPage({this.message}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Center(
                child: Logo(size: 44),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          message == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(20),
                ),
          message == null ? Container() : Text(message),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          TwitchButton(
            child: const Text(
              'Sign in with Twitch',
            ),
            onPressed: () {
              Auth.demo = false;
              Navigator.pushReplacement(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return IndexScreen(runner: Runner.me(context));
              }));
            },
          ),
          FlatButton(
            child: const Text(
              'Sign in with Splits.io',
            ),
            onPressed: () {
              Auth.demo = false;
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return DemoSignInScreen();
              }));
            },
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
