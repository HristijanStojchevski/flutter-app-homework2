import 'package:flutter/material.dart';
import 'package:homework2/model/user.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/constants.dart';
import 'package:homework2/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {

  final Function authComplete;
  final Function showSignInScreen;
  Register({ required this.showSignInScreen, required this.authComplete });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  // global form key
  final _formKey = GlobalKey<FormState>();

  // states
  String email = '';
  String pass = '';
  String name = '';
  String surname = '';
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingScreen() : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[600],
        elevation: 0.0,
        title: Text('Sign up to the Helper!'),
        actions: <Widget>[
          TextButton.icon(
            label: Text('Sign in', style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.person, color: Colors.white,),
            onPressed: () => widget.showSignInScreen(),
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'You must enter an email address !';
                    }
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = RegExp(pattern);
                    if ( regex.hasMatch(val) ) {
                      return null;
                    }
                    else {
                      return 'You must enter a valid email address !';
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'You must enter a password !';
                    }
                    if (val.length < 6) {
                      return 'Password must have at least 6 characters !';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      pass = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'You must enter your name !';
                    }
                    if (val.length < 1) {
                      return 'Name must be at least 1 letter!';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Surname'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'You must enter your surname !';
                    }
                    if (val.length < 1) {
                      return 'Surname must be at least 1 letter!';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      surname = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue[600]
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        setState(() => isLoading = true);
                        AppUser? loggedInUser = await _auth.registerWithEmailAndPassword(email, pass, name, surname);
                        if (loggedInUser == null) {
                          setState(() {
                            error = 'There was an error registering you with that email.';
                            isLoading = false;
                          });
                        }
                        else{
                          widget.authComplete(_auth);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('userEmail', email);
                          await prefs.setString('encryptedPass', pass);
                        }
                      }
                    },
                    child: Text('Register', style: TextStyle(color: Colors.white),)
                ),
                SizedBox(height: 12.0),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),)
              ],
            ),
          )
      ),
    );
  }
}
