enum METHOD {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

extension MethodExtension on METHOD {
  String get value {
    switch (this) {
      case METHOD.GET:
        return 'GET';
      case METHOD.POST:
        return 'POST';
      case METHOD.PUT:
        return 'PUT';
      case METHOD.PATCH:
        return 'PATCH';
      case METHOD.DELETE:
        return 'DELETE';
      default:
        return '';
    }
  }
}

