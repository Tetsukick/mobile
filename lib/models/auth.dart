import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/index.dart';

class NoToken {}

class Auth {
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
  static final _storage = new FlutterSecureStorage();
  static final Set<String> _usedCodes = Set<String>();

  static Future<String> _token;
  static Future<DateTime> _expiry;
  static Future<Runner> _runner;

  static void clear() {
    _token = null;
    _expiry = null;
    _runner = null;

    _storage.deleteAll();
  }

  static Future<String> token() async {
    if (_token != null) {
      return _token;
    }

    _token = _storage.read(key: 'splitsio_access_token');
    if (_token == null) {
      throw NoToken();
    }
    return _token;
  }

  static Future<bool> expired() async {
    if (_expiry != null) {
      return _expiry.then((expiry) => expiry.isBefore(DateTime.now()));
    }

    _expiry = _storage.read(key: 'splitsio_access_token_expiry').then(
        (expiry) => expiry == null ? DateTime(1970) : DateTime.parse(expiry));
    return _expiry.then((expiry) => expiry.isBefore(DateTime.now()));
  }

  static void login() async {
    if (await canLaunch(authorizationEndpoint.toString())) {
      await launch(
        authorizationEndpoint.toString(),
      );
    } else {
      throw 'Cannot open Splits.io in browser to authenticate.';
    }
  }

  static void snatchCode(BuildContext context, Uri uri) async {
    if (_usedCodes.contains(uri.queryParameters['code'])) {
      stderr.write('Somehow got a code that was already used');
      return;
    }
    _usedCodes.add(uri.queryParameters['code']);
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }));

    final http.Response response =
        await http.post("https://splits.io/oauth/token", body: {
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
    _token = Future.value(token);
    _expiry = Future.value(
        DateTime.now().add(Duration(seconds: body['expires_in'] as int)));

    _storage.write(
      key: 'splitsio_access_token',
      value: (await _token),
    );
    _storage.write(
      key: 'splitsio_refresh_token',
      value: body['refresh_token'] as String,
    );
    _storage.write(
      key: 'splitsio_access_token_expiry',
      value: (await _expiry).toString(),
    );

    _runner = Runner.byToken(token);

    _runner.then((Runner runner) {
      _storage.write(
        key: 'splitsio_access_token_owner_id',
        value: runner.id,
      );
      _storage.write(
        key: 'splitsio_access_token_owner_name',
        value: runner.name,
      );
    });

    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return IndexScreen(token: token, runner: Runner.byToken(token));
    }));
  }
}
