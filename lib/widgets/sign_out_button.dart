import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:splitsio/widgets/landing_page.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton() : super();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return LandingPage(message: 'Signed out. ヾ(￣0￣ )ノ');
            }),
          );
        });
  }
}
