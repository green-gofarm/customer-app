class RequestOptions {
  final Map<String, String>? headers;
  final Map<String, String>? queryParams;
  final dynamic body;

  RequestOptions({
    this.headers,
    this.queryParams,
    this.body,
  });
}