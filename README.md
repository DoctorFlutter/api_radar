# API Radar 📡

A powerful, floating debugging tool for Flutter that inspects network traffic (Dio) in real-time.
Designed for developers who need to debug APIs on the fly without connecting to a computer.

**Stop guessing why your API failed. See it instantly on your device.**


## ✨ Features

* **Plug & Play:** Just wrap your app and add the interceptor.
* **Floating HUD:** A draggable radar button that lives over your app.
* **Live Inspection:** See headers, bodies, and status codes instantly.
* **Smart Error Detection:**
    * 🟢 **Green:** Success (2xx)
    * 🔴 **Red:** Error (4xx/5xx) - Instantly alerts you!
    * 🟠 **Orange:** POST/PUT requests.
* **Safe Mode:** Does not crash your app on 403/404 errors.
* **Copy Support:** Long-press any JSON to copy it to your clipboard.

## Screenshots 📸

|                                                            Success State 🟢                                                            |                                                             Error State 🔴                                                             |                                                              Dashboard 📋                                                              |                                                          Response with Icon ⭐                                                          |
|:--------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://raw.githubusercontent.com/DoctorFlutter/api_radar/refs/heads/main/example/assets/screenshot%20(3).jpeg" width="200"> | <img src="https://raw.githubusercontent.com/DoctorFlutter/api_radar/refs/heads/main/example/assets/screenshot%20(4).jpeg" width="200"> | <img src="https://raw.githubusercontent.com/DoctorFlutter/api_radar/refs/heads/main/example/assets/screenshot%20(1).jpeg" width="200"> | <img src="https://raw.githubusercontent.com/DoctorFlutter/api_radar/refs/heads/main/example/assets/screenshot%20(2).jpeg" width="200"> |

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  api_radar: ^0.0.1
```
## 🚀 Usage
**1. Wrap your App**
   * Initialize ApiRadar in your MaterialApp builder. This ensures the radar floats above all screens and can navigate correctly.
   ```dart
   import 'package:flutter/material.dart';
   import 'package:api_radar/api_radar.dart';

   // 1. Create a Global Key for Navigation
   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

   void main() {
   runApp(const MyApp());
}

    class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
    return MaterialApp(
    // 2. Pass the key to MaterialApp
    navigatorKey: navigatorKey,

    // 3. Initialize ApiRadar in the builder
      builder: (context, child) {
        return ApiRadar(
          navigatorKey: navigatorKey, // Important: Pass the key here too!
          enabled: true, // Tip: Use kDebugMode to auto-hide in release builds
          child: child!,
        );
      },
      home: const HomePage(),
     );
    }
    }
```
   
**2. Add the Interceptor**
* Add RadarInterceptor to your Dio instance. This connects the "Spy" to your network traffic.
```dart
import 'package:dio/dio.dart';
import 'package:api_radar/api_radar.dart';

void setupApi() {
  final dio = Dio();
  
  // Add the spy 🕵️‍♂️
  dio.interceptors.add(RadarInterceptor());
}
```

## 🛠️ Advanced Configuration

**Hiding in Release Mode
You usually don't want users to see the debug button. Use kDebugMode to hide it automatically.**

```dart
import 'package:flutter/foundation.dart'; // Import this

// Inside your builder:
ApiRadar(
  enabled: kDebugMode, // True in Debug, False in Release
  navigatorKey: navigatorKey,
  child: child!,
);
```

**Handling 403/404 Errors Gracefully
By default, Dio throws an exception for 403/404 errors. To let Radar capture them without crashing your app, configure validateStatus:**

```dart
final dio = Dio(
  BaseOptions(
    validateStatus: (status) => true, // Accept all status codes
  ),
);
```

