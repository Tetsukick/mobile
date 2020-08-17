import 'package:flutter/material.dart';
import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/run.dart';
import 'package:splitsio/widgets/game/run/run_details.dart';

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
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    bottom: TabBar(
                      isScrollable: true,
                      // These TabBar children must be in sync with the TabBarView children below
                      tabs: runs
                          .map<Tab>((run) => Tab(text: run.category.name))
                          .toList(),
                    ),
                    title: Text(game.name),
                    floating: true,
                    pinned: true),
              ];
            },
            body: GameBoxArtBackground(
              game: game,
              child: TabBarView(
                  // These TabBarView children must be in sync with the TabBar children above
                  children: runs
                      .map<RunDetails>((run) => RunDetails(run: run))
                      .toList()),
            ),
          ),
        ));
  }
}
