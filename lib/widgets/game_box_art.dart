import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/game.dart';

class GameBoxArt extends StatelessWidget {
  final String token;
  final Game game;

  GameBoxArt({@required this.token, @required this.game});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: InkResponse(
          child: FutureBuilder(
            future: game.cover(),
            builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
              if (snapshot.hasData) {
                return Hero(
                    child: Image.network(snapshot.data.toString()),
                    tag: game.id);
              } else if (snapshot.hasError) {
                return Text(snapshot.error as String);
              }

              return Column(
                children: [
                  Padding(padding: EdgeInsets.all(20)),
                  Text('Loading'),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              );
            },
          ),
          onTap: () async {
            // Even though this can _theoretically_ introduce lag to taps,
            // practically it never will because it's impossible to tap on a
            // game unless its cover is already showing (i.e. the cover future
            // is resolved)
            Uri cover = await game.cover();

            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => GameScreen(
                    game: game, cover: cover, runner: Runner.byToken(token)),
              ),
            );
          }),
    );
  }
}
