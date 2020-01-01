import 'package:flutter/material.dart';
import 'package:splitsio/widgets/logo.dart';

class TimerScreen extends StatelessWidget {
  final String token;

  TimerScreen({this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Logo(size: 22),
      ),
      body: Center(
          child: Column(children: [
        Expanded(
          child: Center(
            child: Text('00:00:00',
                style: TextStyle(
                    fontFamily: 'monospace', fontSize: 60, letterSpacing: -3)),
          ),
          flex: 2,
        ),
        Expanded(
          child: SizedBox.expand(
              child: Row(
            children: [
              Expanded(
                  child: SizedBox.expand(
                      child: RaisedButton(
                    child: Text('Undo', style: TextStyle(fontSize: 30)),
                    color: Colors.red[400],
                    onPressed: () {},
                  )),
                  flex: 1),
              Expanded(
                  child: SizedBox.expand(
                      child: RaisedButton(
                    child: Text('Skip', style: TextStyle(fontSize: 30)),
                    color: Colors.green[400],
                    onPressed: () {},
                  )),
                  flex: 1),
            ],
          )),
          flex: 1,
        ),
        Expanded(
          child: SizedBox.expand(
              child: RaisedButton(
            child: Text('Start', style: TextStyle(fontSize: 40)),
            color: Colors.amber[800],
            onPressed: () {},
          )),
          flex: 2,
        ),
      ])),
    );
  }
}
