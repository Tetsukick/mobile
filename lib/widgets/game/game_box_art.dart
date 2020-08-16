import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/game_screen.dart';

class GameBoxArt extends StatelessWidget {
  final Game game;

  GameBoxArt({@required this.game});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Material(
        child: InkWell(
            child: Hero(
              child: game.cover == Game.defaultCover
                  ? Container(
                      child: Center(child: Text(game.name)),
                      decoration: BoxDecoration(border: Border.all()))
                  : Ink.image(
                      image: Image.network(game.cover.toString(),
                              fit: BoxFit.cover)
                          .image,
                    ),
              tag: game.id,
              // Below required to work around the game box art not having
              // a Material ancestor during Hero transition. See
              // https://github.com/flutter/flutter/issues/34119
              flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) =>
                  Material(child: toHeroContext.widget),
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) =>
                      GameScreen(game: game, runner: Runner.me(context)),
                ),
              );
            }),
      ),
    );
  }
}
