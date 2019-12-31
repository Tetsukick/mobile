import 'package:flutter/material.dart';
import 'package:splitsio/models/run.dart';
import 'package:splitsio/models/runner.dart';

class RunList extends StatelessWidget {
  final Runner runner;
  final String accessToken;

  RunList({@required this.runner, @required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: runner.pbs(accessToken),
      builder: (BuildContext context, AsyncSnapshot<List<Run>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data.map((run) {
              return Card(
                child: ListTile(
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

        return CircularProgressIndicator();
      },
    );
  }
}
