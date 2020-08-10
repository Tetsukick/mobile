import 'package:flutter/material.dart';

import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class SplitsioOAuth2Client extends OAuth2Client {
  SplitsioOAuth2Client(
      {@required String redirectUri, @required String customUriScheme})
      : super(
          authorizeUrl: 'https://splits.io/oauth/authorize',
          tokenUrl: 'https://splits.io/oauth/token',
          redirectUri: redirectUri,
          customUriScheme: customUriScheme,
        );
}

class Auth {
  static const clientId = "qRWoaDNtJnPMnsoR-oh89t40_9RozQMjSv04-hVDnBg";
  static const clientSecret = "wlWBUaImnBlP0gs8MTNisM4qfL7WTrFPzMkp8Z4L-1Q";
  static final Set<String> scopes =
      Set.from(<String>['upload_run', 'delete_run', 'manage_race']);
  static const customUriScheme =
      'splitsio'; // Must be kept in sync with AndroidManifest.xml & Info.plist

  static final OAuth2Helper http = OAuth2Helper(
      SplitsioOAuth2Client(
          redirectUri: 'splitsio://splits.io/auth/splitsio/callback',
          customUriScheme: customUriScheme),
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: clientId,
      clientSecret: clientSecret,
      scopes: scopes.toList());
}
