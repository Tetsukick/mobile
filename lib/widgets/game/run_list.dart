import 'dart:async';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/run.dart';
import 'package:splitsio/models/runner.dart';

class RunList extends StatelessWidget {
  final Game game;
  final Future<Runner> runner;

  RunList({@required this.game, @required this.runner});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: runner.then((runner) => runner.pbsByGame(context, game)),
      builder: (BuildContext context, AsyncSnapshot<Iterable<Run>> snapshot) {
        if (snapshot.hasData) {
          return Column(
              children: snapshot.data
                  .toList()
                  .map(
                    (Run run) => Card(
                        child: Container(
                            child: Padding(
                                child: OutlineButton(
                                  onPressed: () async {
                                    if (await canLaunch(run.uri().toString())) {
                                      await launch(run.uri().toString());
                                    } else {
                                      throw 'Cannot open Splits.io in browser.';
                                    }
                                  },
                                  child: ListTile(
                                      title: Text(run.category.name),
                                      trailing: Text.rich(TextSpan(
                                          text: run.duration(),
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            letterSpacing: -1,
                                            fontSize: 18,
                                          ),
                                          children: [
                                            WidgetSpan(
                                                child: Padding(
                                                    child:
                                                        Icon(Icons.open_in_new),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0)))
                                          ]))),
                                ),
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5)))),
                  )
                  .toList());
        } else if (snapshot.hasError) {
          return Text("Couldn't fetch your PBs :(");
        }

        return Center(
            child: Column(
          children: [
            Padding(padding: EdgeInsets.all(20)),
            CircularProgressIndicator(),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
      },
    );
  }
}
