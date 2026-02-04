import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'radar_dashboard.dart';
import '../controller/radar_controller.dart';

class RadarButton extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const RadarButton({super.key, this.navigatorKey});

  @override
  State<RadarButton> createState() => _RadarButtonState();
}

class _RadarButtonState extends State<RadarButton> {
  Offset position = const Offset(300, 500);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: Material(
          type: MaterialType.transparency,
          child: _buildFab(),
        ),
        childWhenDragging: Container(),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          setState(() {
            position = offset;
          });
        },
        child: _buildFab(),
      ),
    );
  }

  Widget _buildFab() {
    return AnimatedBuilder(
      animation: RadarController(),
      builder: (context, _) {
        final hasError = RadarController().logs.any((l) => (l.statusCode ?? 200) >= 400);

        return GestureDetector(
          onTap: () {
            if (widget.navigatorKey?.currentState != null) {
              widget.navigatorKey!.currentState!.push(
                MaterialPageRoute(builder: (_) => const RadarDashboard()),
              );
            } else {
              debugPrint("Error: ApiRadar needs a navigatorKey to open Dashboard!");
            }
          },
          child: Material(
            elevation: 10,
            shape: const CircleBorder(),
            color: Colors.transparent,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasError ? Colors.redAccent : const Color(0xFF1E1E1E),
                border: Border.all(color: Colors.greenAccent, width: 2),
                boxShadow: [
                  BoxShadow(
                    // FIX: Use withValues(alpha: ...) instead of withOpacity
                    color: Colors.greenAccent.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Icon(Icons.radar, color: Colors.greenAccent),
            ),
          ),
        );
      },
    );
  }
}