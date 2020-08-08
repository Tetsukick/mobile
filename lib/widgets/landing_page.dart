import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uni_links/uni_links.dart';

import 'package:splitsio/models/auth.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/index.dart';
import 'package:splitsio/widgets/logo.dart';

class LandingPage extends StatelessWidget {
  LandingPage() : super();
  static const redirectUri = "splitsio://splits.io/auth/splitsio/callback";
  static final clientId = "qRWoaDNtJnPMnsoR-oh89t40_9RozQMjSv04-hVDnBg";
  static final clientSecret = "wlWBUaImnBlP0gs8MTNisM4qfL7WTrFPzMkp8Z4L-1Q";
  static final authorizationEndpoint =
      Uri.https('splits.io', '/oauth/authorize', {
    'response_type': 'code',
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'scope': 'upload_run delete_run manage_race',
  });
  static final storage = new FlutterSecureStorage();
  static StreamSubscription _sub;
  final Set<String> usedCodes = Set<String>();

  Future<void> initUniLinks(BuildContext context) async {
    try {
      final uri = await getInitialUri();
      if (uri != null) {
        snatchCode(context, uri);
      }
      _sub = getUriLinksStream().listen((Uri uri) {
        snatchCode(context, uri);
      }, onError: (Object err) {
        stderr.writeln(err);
      });
    } on PlatformException {}
  }

  void dispose() {
    _sub.cancel();
  }

  Future<void> snatchCode(BuildContext context, Uri uri) async {
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

      final Map<String, dynamic> body =
          await json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        debugPrint("${body['error']} - ${body['error_description']}");
        return;
      }

      String token = body['access_token'] as String;

      storage.write(
        key: 'splitsio_access_token',
        value: token,
      );
      storage.write(
        key: 'splitsio_refresh_token',
        value: body['refresh_token'] as String,
      );
      storage.write(
        key: 'splitsio_access_token_expiry',
        value: DateTime.now()
            .add(Duration(seconds: body['expires_in'] as int))
            .toString(),
      );

      final Future<Runner> runner =
          Runner.byToken(body['access_token'] as String);

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
        return IndexScreen(runner: runner, token: token);
      }));
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    initUniLinks(context);

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
          onPressed: Auth.login,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
