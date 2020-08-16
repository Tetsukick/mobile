import 'package:flutter/material.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game/game_list.dart';
import 'package:splitsio/widgets/shared/logo.dart';
import 'package:splitsio/widgets/shared/sign_out_button.dart';

class IndexScreen extends StatelessWidget {
  final Future<Runner> runner;

  IndexScreen({@required this.runner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          SignOutButton(),
        ],
        title: Logo(size: 22),
      ),
      body: GameList(
        runner: runner,
      ),
    );
  }
}
