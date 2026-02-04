import 'package:flutter/foundation.dart';
import '../models/api_log.dart';

class RadarController extends ChangeNotifier {
  // 1. Create a private static instance
  static final RadarController _instance = RadarController._internal();

  // 2. Public factory to access it
  factory RadarController() => _instance;

  // 3. Private constructor
  RadarController._internal();

  // The list of logs
  final List<ApiLog> _logs = [];

  // Getter (We reverse it so the newest logs appear at the top)
  List<ApiLog> get logs => _logs.reversed.toList();

  // Add a new log and tell Flutter to update the UI
  void addLog(ApiLog log) {
    _logs.add(log);
    notifyListeners();
  }

  // Clear logs (for the 'Trash' button)
  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }
}