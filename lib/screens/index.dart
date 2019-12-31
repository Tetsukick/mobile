import 'package:flutter/material.dart';
import 'package:splitsio/widgets/run_list.dart';
import 'package:splitsio/models/runner.dart';

class IndexScreen extends StatelessWidget {
  final Runner runner;

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
          appBar: AppBar(title: Text('Splits.io')),
          body: Center(child: RunList(runner: runner)),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
          ),
        ));
  }
}
