import 'package:flutter/material.dart';
import 'package:splitsio/models/auth.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/demo_sign_in.dart';
import 'package:splitsio/screens/index.dart';
import 'package:splitsio/widgets/logo.dart';

Color twitchPurple = Color(0xFF916FF);
ColorScheme twitchColorScheme = ColorScheme(
  background: twitchPurple,
  brightness: Brightness.dark,
  error: Colors.red,
  onBackground: twitchPurple,
  onError: Colors.white,
  onPrimary: twitchPurple,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  primary: twitchPurple,
  primaryVariant: twitchPurple,
  secondary: twitchPurple,
  secondaryVariant: twitchPurple,
  surface: Colors.white,
);

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
          ButtonTheme(
            child: RaisedButton(
              child: const Text(
                'Sign in with Twitch',
              ),
              onPressed: () {
                Auth.demo = false;
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return IndexScreen(runner: Runner.me());
                }), (route) => false);
              },
            ),
            textTheme: ButtonTextTheme.normal,
            colorScheme: twitchColorScheme,
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
