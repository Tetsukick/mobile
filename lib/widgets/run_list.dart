import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:splitsio/models/run.dart';
import 'package:splitsio/models/runner.dart';

class RunList extends StatelessWidget {
  final Future<Runner> runner;
  final String accessToken;

  RunList({@required this.runner, @required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: runner.then((runner) => runner.pbs(accessToken)),
      builder: (BuildContext context, AsyncSnapshot<List<Run>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data.map((run) {
              return Card(
                child: ListTile(
                  onLongPress: () async {
                    if (await canLaunch("https://splits.io/${run.id}")) {
                    await launch("https://splits.io/${run.id}");
                    } else {
                    throw 'Cannot open Splits.io in browser.';
                    }
                  },
                  onTap: () async {
                    if (await canLaunch("https://splits.io/${run.id}")) {
                      await launch("https://splits.io/${run.id}");
                    } else {
                      throw 'Cannot open Splits.io in browser.';
                    }
                  },
                  subtitle: Text(run.category.name),
                  title: Text(run.game.name),
                  trailing: Text(run.duration(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        letterSpacing: -1,
                        fontSize: 18,
                      )),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        return Column(
          children: [
            Padding(padding: EdgeInsets.all(20)),
            CircularProgressIndicator()
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}
