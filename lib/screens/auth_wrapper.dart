import 'package:customer_app/main.dart';
import 'package:customer_app/screens/SplashScreen.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _startAuthListener();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _stopAuthListener();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startAuthListener();
    } else {
      _stopAuthListener();
    }
  }

  void _startAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      final currentRoute = NavigationHistoryObserver().top?.settings.name;

      if (user == null) {
        authStore.setUser(null);

          if (currentRoute == null) {
            navigatorKey.currentState
                ?.pushReplacementNamed(RoutePaths.SIGN_IN.value);
            return;
          }

          if (currentRoute == RoutePaths.SIGN_IN.value ||
              currentRoute == RoutePaths.SIGN_UP.value) {
            return;
          }

          navigatorKey.currentState
              ?.pushReplacementNamed(RoutePaths.SIGN_IN.value);
        }
    });
  }

  void _stopAuthListener() {
    FirebaseAuth.instance?.authStateChanges().listen(null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushReplacementNamed(RoutePaths.SPLASH.value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
