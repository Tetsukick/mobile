import 'package:flutter/material.dart';
import 'package:splitsio/models/auth.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/screens/index.dart';

class DemoSignInScreen extends StatelessWidget {
  DemoSignInScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign in with Splits.io")),
      body: Column(children: [
        SignInForm(),
      ]),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class SignInFormState extends State<SignInForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  void _submit() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a Snackbar.
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Signing in')));

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute<void>(builder: (BuildContext context) {
        Auth.demo = true;
        return IndexScreen(runner: Runner.me(context));
      }), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(hintText: "Username"),
              focusNode: _usernameFocus,
              onFieldSubmitted: (term) {
                _usernameFocus.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocus);
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a username';
                }
                if (value != "demo") {
                  return 'Incorrect username';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(hintText: "Password"),
              focusNode: _passwordFocus,
              obscureText: true,
              onFieldSubmitted: (value) => _submit(),
              textInputAction: TextInputAction.go,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value != "demo") {
                  return 'Incorrect password';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: RaisedButton(
                onPressed: _submit,
                child: Text('Sign in', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
                "Sign in with Splits.io is in early access. If you're not sure if you have it, you probably don't."),
          )
        ],
      ),
    );
  }
}
