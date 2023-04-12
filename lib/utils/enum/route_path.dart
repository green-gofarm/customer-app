enum RoutePaths {
  SPLASH,
  SIGN_IN,
  SIGN_UP,
  HOME,
  FARMSTAY_DETAIL,
  ACTIVITY_DETAIL,
  ROOM_DETAIL,
}

extension RoutePathsExtension on RoutePaths {
  String get value {
    switch (this) {
      case RoutePaths.SPLASH:
        return "/splash";
      case RoutePaths.SIGN_IN:
        return "/sign-in";
      case RoutePaths.SIGN_UP:
        return "/sign-up";
      case RoutePaths.HOME:
        return "/home";
      case RoutePaths.FARMSTAY_DETAIL:
        return "/farmstay";
      case RoutePaths.ACTIVITY_DETAIL:
        return "/activity";
      case RoutePaths.ROOM_DETAIL:
        return "/room";
    }
  }
}
