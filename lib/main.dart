import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/index.dart';
import 'package:splitsio/widgets/logo.dart';

void main() => runApp(Splitsio());

class Splitsio extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splits.io',
      theme: ThemeData(
        accentColor: Colors.amber,
        primarySwatch: Colors.amber,
      ),
      darkTheme: ThemeData(
        accentColor: Colors.amber,
        backgroundColor: const Color(0xFF1A1C21),
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  LandingPage() : super();
  static const redirectUri = "splitsio://splits.io/auth/splitsio/callback";
  static final clientId = "qRWoaDNtJnPMnsoR-oh89t40_9RozQMjSv04-hVDnBg";
  static final clientSecret = "wlWBUaImnBlP0gs8MTNisM4qfL7WTrFPzMkp8Z4L-1Q";
  static final authorizationEndpoint =
      Uri(scheme: 'https', host: 'splits.io', pathSegments: [
    'oauth',
    'authorize'
  ], queryParameters: {
    'response_type': 'code',
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'scope': 'upload_run+delete_run+manage_race',
  });
  static final storage = new FlutterSecureStorage();
  static StreamSubscription _sub;
  final Set<String> usedCodes = Set<String>();

  Future<Null> initUniLinks(BuildContext context) async {
    try {
      final uri = await getInitialUri();
      if (uri != null) {
        snatchCode(context, uri);
      }
      _sub = getUriLinksStream().listen((Uri uri) {
        snatchCode(context, uri);
      }, onError: (err) {
        stderr.writeln(err);
      });
    } on PlatformException {}
  }

  void dispose() {
    _sub.cancel();
  }

  void snatchCode(BuildContext context, Uri uri) async {
    DateTime expiry = DateTime.parse(await storage.read(
      key: 'splitsio_access_token_expiry',
    ));

    if (DateTime.now().isBefore(expiry)) {
      return;
    }

    if (usedCodes.contains(uri.queryParameters['code'])) {
      return;
    }
    usedCodes.add(uri.queryParameters['code']);

    try {
      Navigator.push(context, MaterialPageRoute<void>(builder: (context) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }));

      final response = await http.post("https://splits.io/oauth/token", body: {
        "grant_type": "authorization_code",
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": uri.queryParameters["code"],
        "redirect_uri": redirectUri,
      });

      final body = await json.decode(response.body);

      if (response.statusCode != 200) {
        debugPrint("${body['error']} - ${body['error_description']}");
        return;
      }

      storage.write(
        key: 'splitsio_access_token',
        value: body['access_token'],
      );
      storage.write(
        key: 'splitsio_refresh_token',
        value: body['refresh_token'],
      );
      storage.write(
        key: 'splitsio_access_token_expiry',
        value: DateTime.now()
            .add(Duration(seconds: body['expires_in']))
            .toString(),
      );

      final Future<Runner> runner = Runner.byToken(body['access_token']);

      runner.then((Runner runner) {
        storage.write(
          key: 'splitsio_access_token_owner_id',
          value: runner.id,
        );
        storage.write(
          key: 'splitsio_access_token_owner_name',
          value: runner.name,
        );
      });

      Navigator.push(context,
          MaterialPageRoute<void>(builder: (BuildContext context) {
        return IndexScreen(runner: runner);
      }));
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    initUniLinks(context);

    Future.wait([
      storage.read(key: 'splitsio_access_token'),
      storage.read(key: 'splitsio_access_token_expiry'),
    ]).then((List<String> vals) {
      String token = vals[0];
      String expiry = vals[1];

      if (DateTime.parse(expiry).isAfter(DateTime.now())) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) {
            return IndexScreen(runner: Runner.byToken(token));
          }),
        );
      }
    });

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Center(
                child: Logo(size: 44),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          final token = await storage.read(key: 'splitsio_access_token');
          if (token != null) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) {
                return IndexScreen(runner: Runner.byToken(token));
              }),
            );
          }
          if (await canLaunch(authorizationEndpoint.toString())) {
            await launch(authorizationEndpoint.toString());
          } else {
            throw 'Cannot open Splits.io in browser to authenticate.';
          }
        },
      ),
    );
  }
}
