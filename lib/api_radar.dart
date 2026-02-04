import 'package:flutter/material.dart';
import 'src/ui/radar_button.dart';

// Export parts for the user
export 'src/interceptor/radar_interceptor.dart';
export 'src/controller/radar_controller.dart';

class ApiRadar extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final GlobalKey<NavigatorState>? navigatorKey; // 1. Add this key

  const ApiRadar({
    super.key,
    required this.child,
    this.enabled = true,
    this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Directionality(
      textDirection: TextDirection.ltr,
      // 2. Wrap everything in an Overlay. This fixes "No Overlay widget found"!
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Stack(
              children: [
                child, // The User's App (Navigator)
                // Pass the key to the button so it can find the Navigator
                RadarButton(navigatorKey: navigatorKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}