import 'package:flutter/material.dart';
import 'package:splitsio/models/auth.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/index.dart';
import 'package:splitsio/widgets/logo.dart';

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
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        floatingActionButton: InkWell(
            child: FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () => [
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return IndexScreen(runner: Runner.me());
                }), (route) => false)
              ],
            ),
            onLongPress: () {
              Auth.demo = true;
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return IndexScreen(runner: Runner.me());
              }), (route) => false);
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
