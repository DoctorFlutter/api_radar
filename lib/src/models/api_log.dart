class ApiLog {
  final String id;
  final String method; // GET, POST, PUT
  final String url;
  final int? statusCode;
  final int durationMs; // Time taken in milliseconds
  final DateTime startTime;

  // Request Data
  final Map<String, dynamic>? requestHeaders;
  final dynamic requestBody;

  // Response Data
  final Map<String, dynamic>? responseHeaders;
  final dynamic responseBody;
  final String? errorMsg;

  ApiLog({
    required this.id,
    required this.method,
    required this.url,
    this.statusCode,
    required this.durationMs,
    required this.startTime,
    this.requestHeaders,
    this.requestBody,
    this.responseHeaders,
    this.responseBody,
    this.errorMsg,
  });
}