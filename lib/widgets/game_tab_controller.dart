import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/run.dart';
import 'package:url_launcher/url_launcher.dart';

import 'game_box_art_background.dart';

class GameTabController extends StatelessWidget {
  final Game game;
  final Iterable<Run> runs;
  final Uri cover;

  GameTabController(
      {@required this.game, @required this.runs, @required this.cover});

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: runs.length,
        child: Scaffold(
          appBar: AppBar(
              bottom: TabBar(
                  tabs:
                      runs.map((run) => Tab(text: run.category.name)).toList()),
              title: Text(game.name)),
          body: Stack(children: [
            GameBoxArtBackground(
              cover: cover,
              game: game,
              child: TabBarView(
                  children: runs
                      .map((run) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: OutlineButton(
                                    child: ListTile(
                                      title: Text(run.duration(),
                                          style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 30)),
                                      trailing: Icon(Icons.open_in_new),
                                    ),
                                    onPressed: () async {
                                      if (await canLaunch(
                                          run.uri().toString())) {
                                        await launch(run.uri().toString());
                                      } else {
                                        throw 'Cannot open Splits.io in browser.';
                                      }
                                    }),
                              ),
                              Text("from ${run.program}"),
                              Text("on ${run.parsedAt}"),
                              Text("after ${run.attempts} attempts"),
                              Text("using ${run.defaultTiming.name}"),
                            ],
                          ))
                      .toList()),
            ),
          ]),
        ));
  }
}
