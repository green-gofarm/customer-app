
enum RoutePaths { SPLASH, SIGN_IN, SIGN_UP, HOME, AUTH_WRAPPER }

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
      case RoutePaths.AUTH_WRAPPER:
        return "/auth";
    }
  }
}
