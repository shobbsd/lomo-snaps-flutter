import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './Events.dart';

Future<Map> _handleSignIn(String email, String password) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
  final Map userInfo = await Firestore.instance
      .collection('users')
      .document(user.uid)
      .get()
      .then((doc) => doc.data);

  // print(userDoc);

  return userInfo;
}

// Create a Form Widget

// Create a Form Widget
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class _LogInData {
  String email = '';
  String password = '';
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class LoginPageState extends State<LoginPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<LoginPageState>!
  final _formKey = GlobalKey<FormState>();

  _LogInData _data = new _LogInData();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            onSaved: (value) => this._data.email = value,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                icon: Icon(Icons.email), labelText: 'Email Address'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          TextFormField(
            onSaved: (value) => this._data.password = value,
            obscureText: true,
            decoration: const InputDecoration(
                icon: Icon(Icons.https), labelText: 'Password'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, we want to show a Snackbar
                      _formKey.currentState.save();
                      _handleSignIn(_data.email, _data.password)
                          .then((user) => {
                                Navigator.of(context).pushAndRemoveUntil(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EventsDashboard(user)),
                                    (Route route) => route == null)
                              });
                    }
                  },
                  child: Text('Submit'),
                ),
              )),
        ],
      ),
    );
  }
}
