class RouteConstants {
  static const String SPLASH = "/splash";
  static const String SIGN_IN = "/sign-in";
  static const String SIGN_UP = "/sign-up";
  static const String HOME = "/home";
  static const String FARMSTAY_DETAIL = "/farmstay";
  static const String ACTIVITY_DETAIL = "/activity";
  static const String ROOM_DETAIL = "/room";
  static const String CART_LIST = "/carts";
  static const String BOOKING_DETAIL = "/booking-detail";
}

enum RoutePaths {
  SPLASH,
  SIGN_IN,
  SIGN_UP,
  HOME,
  FARMSTAY_DETAIL,
  ACTIVITY_DETAIL,
  ROOM_DETAIL,
  CART_LIST,
  BOOKING_DETAIL
}

extension RoutePathsExtension on RoutePaths {
  String get value {
    switch (this) {
      case RoutePaths.SPLASH:
        return RouteConstants.SPLASH;
      case RoutePaths.SIGN_IN:
        return RouteConstants.SIGN_IN;
      case RoutePaths.SIGN_UP:
        return RouteConstants.SIGN_UP;
      case RoutePaths.HOME:
        return RouteConstants.HOME;
      case RoutePaths.FARMSTAY_DETAIL:
        return RouteConstants.FARMSTAY_DETAIL;
      case RoutePaths.ACTIVITY_DETAIL:
        return RouteConstants.ACTIVITY_DETAIL;
      case RoutePaths.ROOM_DETAIL:
        return RouteConstants.ROOM_DETAIL;
      case RoutePaths.CART_LIST:
        return RouteConstants.CART_LIST;
      case RoutePaths.BOOKING_DETAIL:
        return RouteConstants.BOOKING_DETAIL;
    }
  }

  static RoutePaths fromValue(String value) {
    switch (value) {
      case RouteConstants.SPLASH:
        return RoutePaths.SPLASH;
      case RouteConstants.SIGN_IN:
        return RoutePaths.SIGN_IN;
      case RouteConstants.SIGN_UP:
        return RoutePaths.SIGN_UP;
      case RouteConstants.HOME:
        return RoutePaths.HOME;
      case RouteConstants.FARMSTAY_DETAIL:
        return RoutePaths.FARMSTAY_DETAIL;
      case RouteConstants.ACTIVITY_DETAIL:
        return RoutePaths.ACTIVITY_DETAIL;
      case RouteConstants.ROOM_DETAIL:
        return RoutePaths.ROOM_DETAIL;
      case RouteConstants.CART_LIST:
        return RoutePaths.CART_LIST;
      case RouteConstants.BOOKING_DETAIL:
        return RoutePaths.BOOKING_DETAIL;
      default:
        throw ArgumentError('Invalid route value: $value');
    }
  }
}
