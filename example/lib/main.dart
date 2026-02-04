import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:api_radar/api_radar.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Radar Test',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.greenAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.blueAccent,
        ),
      ),
      builder: (context, child) {
        return ApiRadar(
          enabled: true,
          navigatorKey: navigatorKey,
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio(
      BaseOptions(
        validateStatus: (status) => true,
        headers: {
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0 Safari/537.36",
        },
      ),
    );
    _dio.interceptors.add(RadarInterceptor());
  }

  Future<void> testSuccess() async {
    try {
      await _dio.get('https://api.adviceslip.com/advice');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success! Check the Radar 🟢")),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> testError() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/this-page-does-not-exist');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Server returned ${response.statusCode}! Check Radar 🔴"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> testPost() async {
    await _dio.post(
      'https://jsonplaceholder.typicode.com/posts',
      data: {
        'title': 'Testing API Radar',
        'body': 'This is a test body sent from Flutter.',
        'userId': 1,
      },
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("POST Sent! Check the Radar 🟠")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Radar Test 📡"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Tap buttons below to generate traffic.\nThe Floating Radar will catch everything!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // FIX: withValues
                  backgroundColor: Colors.greenAccent.withValues(alpha: 0.2),
                  foregroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: testSuccess,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Test Success (200 OK)"),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // FIX: withValues
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: testError,
                icon: const Icon(Icons.error_outline),
                label: const Text("Test Error (404/403)"),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // FIX: withValues
                  backgroundColor: Colors.orangeAccent.withValues(alpha: 0.2),
                  foregroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: testPost,
                icon: const Icon(Icons.send),
                label: const Text("Test POST Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}