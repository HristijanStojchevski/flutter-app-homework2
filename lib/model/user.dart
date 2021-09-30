import 'package:cloud_firestore/cloud_firestore.dart';

enum Role {
  Explorer, Activist
}

extension RoleExtension on Role {

  static const names = {
    Role.Explorer: 'Explorer',
    Role.Activist: 'Activist'
  };

  String? get name => names[this];
}

class AppUser {
  AppUser._privateConstructor();

  static final AppUser _appUser = AppUser._privateConstructor();

  factory AppUser(){
    return _appUser;
  }

  String? uid;
  Role role = Role.Explorer;
  List<DocumentReference> activities = [];
  String name = '';
  String surname = '';
  String email = '';
  String username = '';
  String deviceToken = '';
  bool isLoggedIn = false;
}