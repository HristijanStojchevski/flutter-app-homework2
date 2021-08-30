import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/user.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/widgets/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Firebase
    // Firebase.initializeApp()

    return StreamProvider<AppUser?>.value(
      value: AuthService().authChanges,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
