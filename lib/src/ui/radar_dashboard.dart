import 'package:flutter/material.dart';
import '../controller/radar_controller.dart';
import '../models/api_log.dart';
import 'api_details_page.dart';

class RadarDashboard extends StatelessWidget {
  const RadarDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        elevation: 0,
        title: const Text("API Radar 📡", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            onPressed: () => RadarController().clearLogs(),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: RadarController(),
        builder: (context, _) {
          final logs = RadarController().logs;
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_tethering_off, size: 64, color: Colors.grey[800]),
                  const SizedBox(height: 16),
                  const Text("No Traffic Detected",
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: logs.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final log = logs[index];
              return _ProApiTile(log: log);
            },
          );
        },
      ),
    );
  }
}

class _ProApiTile extends StatelessWidget {
  final ApiLog log;
  const _ProApiTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final code = log.statusCode ?? 0;
    final isError = code >= 400;
    final statusColor = isError ? Colors.redAccent : Colors.greenAccent;
    final methodColor = _getMethodColor(log.method);

    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        // FIX: withValues
          side: BorderSide(color: isError ? Colors.red.withValues(alpha: 0.5) : Colors.transparent),
          borderRadius: BorderRadius.circular(12)
      ),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ApiDetailsPage(log: log))
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      // FIX: withValues
                      color: methodColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                        log.method,
                        style: TextStyle(color: methodColor, fontWeight: FontWeight.bold, fontSize: 12)
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      log.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: statusColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
                            color: statusColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "$code ${isError ? 'Error' : 'OK'}",
                          style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.timer_outlined, color: Colors.grey[600], size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${log.durationMs} ms",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET': return Colors.blueAccent;
      case 'POST': return Colors.orangeAccent;
      case 'PUT': return Colors.purpleAccent;
      case 'DELETE': return Colors.redAccent;
      default: return Colors.grey;
    }
  }
}