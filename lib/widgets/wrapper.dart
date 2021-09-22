import 'package:flutter/material.dart';
import 'package:homework2/model/user.dart';
import 'package:homework2/widgets/auth/authenticate.dart';
import 'package:homework2/widgets/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final appUser = Provider.of<AppUser?>(context);
    // print(appUser);

    return appUser != null ? Home() : Authenticate() ;
  }
}
