import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitsio/models/run.dart';
import 'package:url_launcher/url_launcher.dart';

class RunDetails extends StatelessWidget {
  final Run run;

  const RunDetails({
    Key key,
    @required this.run,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: OutlineButton(
              child: ListTile(
                title: Center(
                  child: Text(run.duration(),
                      style: TextStyle(fontFamily: 'monospace', fontSize: 30)),
                ),
                // iOS won't allow us to link to our website, since from there you can get to our payment page and they don't like that
                trailing: Platform.isIOS ? null : Icon(Icons.open_in_new),
              ),
              onPressed: () async {
                if (Platform.isIOS) {
                  return;
                }
                if (await canLaunch(run.uri().toString())) {
                  await launch(run.uri().toString());
                } else {
                  throw 'Cannot open Splits.io in browser.';
                }
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Center(
            child: Wrap(children: [
              Chip(label: Text(run.program)),
              Padding(padding: EdgeInsets.only(left: 4, right: 4)),
              Chip(label: Text(run.uploadDate())),
              Padding(padding: EdgeInsets.only(left: 4, right: 4)),
              Chip(label: Text("${run.attempts} attempts")),
              Padding(padding: EdgeInsets.only(left: 4, right: 4)),
              Chip(label: Text(run.defaultTiming.name)),
            ]),
          ),
        ),
        Column(
          children: run.segments.map((segment) {
            return Card(
              child: ListTile(
                title: Text(segment.displayName),
                subtitle: Text("${segment.realtimeDuration}"),
                trailing: Text("${segment.realtimeEnd}"),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
