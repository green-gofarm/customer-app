import 'package:customer_app/main.dart';
import 'package:customer_app/screens/SplashScreen.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance?.authStateChanges().listen((User? user) {
      if (user == null) {
        authStore.setUser(null);
        Navigator.pushReplacementNamed(context, RoutePaths.SIGN_IN.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
