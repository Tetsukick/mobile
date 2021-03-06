import 'dart:async';

import 'package:flutter/material.dart';

import 'package:splitsio/sentry.dart';
import 'package:splitsio/screens/landing_page.dart';

void main() => runZonedGuarded<Future<void>>(() async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if (isInDebugMode) {
          FlutterError.dumpErrorToConsole(details);
        } else {
          Zone.current.handleUncaughtError(details.exception, details.stack);
        }
      };

      runApp(Splitsio());
    }, (Object error, StackTrace stackTrace) {
      reportError(error, stackTrace);
    });

class Splitsio extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splits.io',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lime,
      ),
      darkTheme: ThemeData(
        accentColor: Colors.amber,
        backgroundColor: const Color(0xFF1A1C21),
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: LandingPage(),
    );
  }
}
