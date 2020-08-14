import 'package:flutter/material.dart';
import 'package:splitsio/models/auth.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/demo_sign_in.dart';
import 'package:splitsio/screens/index.dart';
import 'package:splitsio/widgets/logo.dart';
import 'package:splitsio/widgets/twitch_button.dart';

class LandingPage extends StatelessWidget {
  LandingPage() : super();

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
          Padding(
            padding: EdgeInsets.all(20),
          ),
          TwitchButton(
            child: const Text(
              'Sign in with Twitch',
            ),
            onPressed: () {
              Auth.demo = false;
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return IndexScreen(runner: Runner.me(context));
              }), (route) => false);
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
