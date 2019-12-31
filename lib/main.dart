import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:splitsio/screens/index.dart';
import 'package:splitsio/models/runner.dart';

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
  static final authorizationEndpoint = Uri.parse(
      "https://splits.io/oauth/authorize?response_type=code&scope=upload_run+delete_run+manage_race&redirect_uri=$redirectUri&client_id=$clientId");
  static final storage = new FlutterSecureStorage();
  static StreamSubscription _sub;

  Future<Null> initUniLinks(BuildContext context) async {
    try {
      final uri = await getInitialUri();
      if (uri != null) {
        snatchCode(context, uri);
      }
      var listen = getUriLinksStream().listen((Uri uri) {
        snatchCode(context, uri);
      }, onError: (err) {});
      _sub = listen;
    } on PlatformException {}
  }

  void snatchCode(BuildContext context, Uri uri) async {
    try {
      Navigator.push(context, MaterialPageRoute<void>(builder: (context) {
        return Center(child: CircularProgressIndicator());
      }));
      final response = await http.post("https://splits.io/oauth/token", body: {
        "grant_type": "authorization_code",
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": uri.queryParameters["code"],
        "redirect_uri": redirectUri,
      });
      final String accessToken = jsonDecode(response.body)["access_token"];
      storage.write(
        key: 'splitsio_access_token',
        value: accessToken,
      );
      storage.write(
        key: 'splitsio_refresh_token',
        value: jsonDecode(response.body)["refresh_token"],
      );
      storage.write(
        key: 'splitsio_access_token_expiry',
        value: DateTime.now()
            .add(Duration(seconds: jsonDecode(response.body)["expires_in"]))
            .toString(),
      );

      final runner = await Runner.byToken(accessToken);
      storage.write(
        key: 'splitsio_access_token_owner_id',
        value: runner.id,
      );
      storage.write(
        key: 'splitsio_access_token_owner_name',
        value: runner.name,
      );
      Navigator.push(context,
          MaterialPageRoute<void>(builder: (BuildContext context) {
        return IndexScreen(runner: runner);
      }));
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    initUniLinks(context);

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo-skinny.png',
              height: 65,
            ),
            Padding(padding: EdgeInsets.all(3)),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'plits.io',
                    style: TextStyle(
                      fontFamily: 'Bukhari Script',
                      fontSize: 50,
                    ),
                  ),
                ],
                style: TextStyle(
                    fontFamily: 'Bukhari Script Alternates', fontSize: 50),
                text: 'S',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.face),
        label: Text('Sign in'),
        onPressed: () async {
          //var client = await oauth2.clientCredentialsGrant(
          //authorizationEndpoint, identifier, secret);
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
