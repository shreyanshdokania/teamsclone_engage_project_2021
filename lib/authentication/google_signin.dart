import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Googlesigninprov extends ChangeNotifier {
  final googlesignin = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future glogin() async {
    final guser = await googlesignin.signIn();

    if (guser == null) return;

    _user = guser;

    final googleauth = await guser.authentication;
    final cred = GoogleAuthProvider.credential(
      accessToken: googleauth.accessToken,
      idToken: googleauth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(cred);
    notifyListeners();
  }

  Future logoutofapp() async {
    await googlesignin.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
