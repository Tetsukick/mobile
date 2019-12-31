import 'package:flutter/material.dart';
import 'package:splitsio/models/run.dart';

class RunList extends StatelessWidget {
  final List<Run> runs;

  RunList({@required this.runs});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:
      this.runs.map((run) {
        return Card(child: ListTile(
          title: Text('Hi'),
        ));
      }).toList(),
    );
  }
}
