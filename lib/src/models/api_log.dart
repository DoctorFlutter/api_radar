class ApiLog {
  final String id;
  final String method; // GET, POST, PUT
  final String url;
  final DateTime startTime;

  // ⚠️ CHANGED: Removed 'final' because we calculate these LATER (when response arrives)
  int? statusCode;
  int? durationMs;

  // Request Data
  final Map<String, dynamic>? requestHeaders;
  final dynamic requestBody;

  // ⚠️ CHANGED: Removed 'final' so we can update them later
  Map<String, dynamic>? responseHeaders;
  dynamic responseBody;
  String? errorMsg;

  ApiLog({
    required this.id,
    required this.method,
    required this.url,
    required this.startTime,
    this.statusCode,
    this.durationMs, // Made optional because we don't know it at the start!
    this.requestHeaders,
    this.requestBody,
    this.responseHeaders,
    this.responseBody,
    this.errorMsg,
  });
}