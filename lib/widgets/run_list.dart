import 'package:flutter/material.dart';
import 'package:splitsio/models/run.dart';
import 'package:splitsio/models/runner.dart';
import 'package:url_launcher/url_launcher.dart';

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
            children: Run.byGame(snapshot.data).keys.map((game) {
              return Card(
                  child: FutureBuilder(
                future: game.cover(),
                builder: (context, coverSnapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.1), BlendMode.dstATop),
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(
                            coverSnapshot.data.toString(),
                          ),
                        )),
                        child: Column(
                          children: List<Widget>.from([
                                Padding(
                                    child: Text(game.name,
                                        style: TextStyle(fontSize: 15)),
                                    padding: EdgeInsets.all(10)),
                              ]) +
                              Run.byGame(snapshot.data)[game]
                                  .map((run) => ListTile(
                                        onTap: () async {
                                          if (await canLaunch(
                                              "https://splits.io/${run.id}")) {
                                            await launch(
                                                "https://splits.io/${run.id}");
                                          } else {
                                            throw 'Cannot open Splits.io in browser.';
                                          }
                                        },
                                        title: Text(run.category.name),
                                        trailing: Text(run.duration(),
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              letterSpacing: -1,
                                              fontSize: 18,
                                            )),
                                      ))
                                  .toList(),
                        ));
                  } else if (snapshot.hasError) {
                    throw snapshot.error;
                  }

                  return Container();
                },
              ));
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
