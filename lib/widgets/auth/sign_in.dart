import 'package:flutter/material.dart';
import 'package:homework2/model/user.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/constants.dart';
import 'package:homework2/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {

  final Function authComplete;
  final Function showRegisterScreen;
  SignIn({ required this.showRegisterScreen, required this.authComplete});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  // global form key
  final _formKey = GlobalKey<FormState>();

  // states
  String email = '';
  String pass = '';
  String error = '';
  bool isLoading = false;

  Future<void> checkUserAuth() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('userEmail');
    String? savedPass = prefs.getString('encryptedPass');
    if(savedEmail == null){
      return;
    }
    if(savedPass == null){
      return;
    }
    setState(() {
      isLoading = true;
    });
    email = savedEmail;
    // TODO decrypt pass
    pass = savedPass;
    dynamic result = await _auth.signInWithEmailAndPassword(email, pass);
    if (result == null){
      error = 'There was a problem with signing you in automatically.\n Please type your email and pass again.';
    } else {
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkUserAuth();
  }
  @override
  Widget build(BuildContext context) {

    return isLoading ? LoadingScreen() : Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[600],
        elevation: 0.0,
        title: Text('Sign in to the Helper!'),
        actions: <Widget>[
          TextButton.icon(
            label: Text('Register', style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.person, color: Colors.white,),
            onPressed: () => widget.showRegisterScreen(),
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
                validator: (val) => val == null || val.isEmpty ? 'You must enter a password !' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    pass = val;
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
                    AppUser? loggedInUser = await _auth.signInWithEmailAndPassword(email, pass);
                    if (loggedInUser == null){
                       setState(() {
                        error = 'There was a problem with signing you in.';
                        isLoading = false;
                       });
                    }
                    else{
                      widget.authComplete(_auth);
                      // final prefs = await SharedPreferences.getInstance();
                      // await prefs.setString('userEmail', email);
                      // await prefs.setString('encryptedPass', pass);
                    }
                  }
                },
                child: Text('Sign in', style: TextStyle(color: Colors.white),)
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
