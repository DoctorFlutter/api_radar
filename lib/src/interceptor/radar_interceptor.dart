import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../controller/radar_controller.dart';
import '../models/api_log.dart';

class RadarInterceptor extends Interceptor {
  final _controller = RadarController();
  final _startTimeMap = <String, DateTime>{}; // Temporary storage for start times

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. Generate a unique ID
    final id = const Uuid().v4();

    // 2. Attach ID to the request object so we can find it later
    options.extra['radar_id'] = id;

    // 3. Record Start Time
    _startTimeMap[id] = DateTime.now();

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logTransaction(response.requestOptions, response: response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logTransaction(err.requestOptions, error: err);
    super.onError(err, handler);
  }

  // Helper function to bundle data and save it
  void _logTransaction(RequestOptions options, {Response? response, DioException? error}) {
    final id = options.extra['radar_id'] as String? ?? '';
    final startTime = _startTimeMap[id] ?? DateTime.now();
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime).inMilliseconds;

    // Create the Log Object
    final log = ApiLog(
      id: id,
      method: options.method,
      url: options.uri.toString(),
      statusCode: response?.statusCode ?? error?.response?.statusCode ?? 0,
      durationMs: duration,
      startTime: startTime,
      requestHeaders: options.headers,
      requestBody: options.data,
      responseBody: response?.data ?? error?.response?.data,
      responseHeaders: response?.headers.map,
      errorMsg: error?.message,
    );

    // Save to Controller
    _controller.addLog(log);

    // Clean up memory
    _startTimeMap.remove(id);
  }
}