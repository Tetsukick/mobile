import 'package:flutter/material.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/timer.dart';
import 'package:splitsio/widgets/logo.dart';
import 'package:splitsio/widgets/run_list.dart';

class IndexScreen extends StatelessWidget {
  final Future<Runner> runner;

  IndexScreen({this.runner});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Splits.io',
        theme: ThemeData(
          accentColor: Colors.amber,
          primarySwatch: Colors.amber,
        ),
        darkTheme: ThemeData(
          accentColor: Colors.amber,
          backgroundColor: const Color(0xFF1A1C21),
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Logo(size: 22),
          ),
          body: ListView(
            children: [
              RunList(runner: runner),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.timer),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (context) {
                return TimerScreen();
              }));
            },
          ),
        ));
  }
}
