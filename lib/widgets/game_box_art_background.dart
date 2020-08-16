import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitsio/models/game.dart';

class GameBoxArtBackground extends StatelessWidget {
  final Game game;
  final Widget child;
  final Uri cover;

  const GameBoxArtBackground(
      {@required this.child, @required this.game, @required this.cover});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.1), BlendMode.dstATop),
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    cover.toString(),
                  ),
                ),
              ),
            ),
          ),
          tag: game.id,
        ),
        BackdropFilter(
            child: child, filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5)),
      ],
    );
  }
}
