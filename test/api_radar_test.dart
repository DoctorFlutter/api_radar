import 'package:flutter_test/flutter_test.dart';
import 'package:api_radar/api_radar.dart';

void main() {
  test('RadarController initializes correctly', () {
    final controller = RadarController();
    controller.clearLogs();
    expect(controller.logs.isEmpty, true);
  });

  test('ApiLog model creates and updates correctly', () {
    // 1. Create the log (Request Start)
    // We MUST provide 'id' because your model requires it.
    final log = ApiLog(
      id: '12345',
      method: 'GET',
      url: 'https://example.com/api',
      startTime: DateTime.now(),
    );

    // 2. Simulate Response arriving (Update values)
    // This works now because we removed 'final' from these fields
    log.statusCode = 200;
    log.durationMs = 150;
    log.responseBody = {"success": true};

    // 3. Verify
    expect(log.id, '12345');
    expect(log.statusCode, 200);
    expect(log.durationMs, 150);
  });
}