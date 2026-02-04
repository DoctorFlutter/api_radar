import 'package:flutter/material.dart';
import 'src/ui/radar_button.dart';

// Export parts for the user
export 'src/interceptor/radar_interceptor.dart';
export 'src/controller/radar_controller.dart';
export 'src/models/api_log.dart';

class ApiRadar extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final GlobalKey<NavigatorState>? navigatorKey;

  const ApiRadar({
    super.key,
    required this.child,
    this.enabled = true,
    this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    // If disabled (e.g. Release Mode), just return the app
    if (!enabled) return child;

    return Directionality(
      textDirection: TextDirection.ltr,
      // FIX: We MUST wrap everything in an Overlay.
      // The Draggable widget searches up the tree for this.
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Stack(
              children: [
                // 1. The User's App (The background)
                child,

                // 2. The Floating Radar Button (On top)
                RadarButton(navigatorKey: navigatorKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}