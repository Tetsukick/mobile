import 'package:flutter/material.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game_list.dart';
import 'package:splitsio/widgets/landing_page.dart';
import 'package:splitsio/widgets/logo.dart';

class IndexScreen extends StatelessWidget {
  final Future<Runner> runner;

  IndexScreen({@required this.runner});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return LandingPage();
                      }),
                    );
                  }),
            ],
            title: Logo(size: 22),
          ),
          body: GameList(
            runner: runner,
          ),
          /*
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.timer),
            heroTag: 'timer',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (context) {
                return TimerScreen();
              }));
            },
          ),
          */
        ));
  }
}
