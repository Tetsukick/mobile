import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/game.dart';

class GameBoxArt extends StatelessWidget {
  final Game game;

  GameBoxArt({@required this.game});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: FutureBuilder(
        future: game.cover(),
        builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
          if (snapshot.hasData) {
            return Material(
              child: InkWell(
                  child: Hero(
                    child: snapshot.data == Game.defaultCover
                        ? Container(
                            child: Center(child: Text(game.name)),
                            decoration: BoxDecoration(border: Border.all()))
                        : Ink.image(
                            image: Image.network(snapshot.data.toString(),
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
                    // Even though this can _theoretically_ introduce lag to taps,
                    // practically it never will because it's impossible to tap on a
                    // game unless its cover is already showing (i.e. the cover future
                    // is resolved)
                    Uri cover = await game.cover();

                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => GameScreen(
                            game: game,
                            cover: cover,
                            runner: Runner.me(context)),
                      ),
                    );
                  }),
            );
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
    );
  }
}
