import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/api_log.dart';

class ApiDetailsPage extends StatelessWidget {
  final ApiLog log;
  const ApiDetailsPage({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    // 🎨 Dracula Theme Colors
    const bgDark = Color(0xFF282A36); // Deep Background
    const bgLighter = Color(0xFF44475A); // Selection/Panel

    // Status Logic
    final isError = (log.statusCode ?? 0) >= 400;
    final statusColor = isError ? const Color(0xFFFF5555) : const Color(0xFF50FA7B); // Dracula Red or Green

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgDark,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgDark,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              // Method Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getMethodColor(log.method).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _getMethodColor(log.method).withOpacity(0.5)),
                ),
                child: Text(
                  log.method,
                  style: TextStyle(
                    color: _getMethodColor(log.method),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // URL Text
              Expanded(
                child: Text(
                  log.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.white70, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          actions: [
            // Status Code Badge with Glow
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 8, spreadRadius: 0),
                ],
                border: Border.all(color: statusColor),
              ),
              child: Text(
                "${log.statusCode}",
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: bgLighter,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: const Color(0xFFBD93F9), // Dracula Purple
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: "Response Body"),
                  Tab(text: "Request & Headers"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _CodeEditor(data: log.responseBody),
            SingleChildScrollView(
              child: Column(
                children: [
                  _InfoSection(title: "REQUEST PAYLOAD", data: log.requestBody),
                  const Divider(color: Colors.white10),
                  _InfoSection(title: "HEADERS", data: log.requestHeaders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET': return const Color(0xFF8BE9FD); // Cyan
      case 'POST': return const Color(0xFFFFB86C); // Orange
      case 'PUT': return const Color(0xFFBD93F9); // Purple
      case 'DELETE': return const Color(0xFFFF5555); // Red
      default: return Colors.white;
    }
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final dynamic data;
  const _InfoSection({required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(title, style: const TextStyle(color: Color(0xFF6272A4), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        SizedBox(
          height: 300, // Fixed height constraint for nested scrolling feel
          child: _CodeEditor(data: data, showCopy: false),
        ),
      ],
    );
  }
}

class _CodeEditor extends StatelessWidget {
  final dynamic data;
  final bool showCopy;

  const _CodeEditor({this.data, this.showCopy = true});

  @override
  Widget build(BuildContext context) {
    if (data == null || data.toString().isEmpty || data == "null") {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code_off, size: 64, color: Colors.white10),
            SizedBox(height: 16),
            Text("No Body Content", style: TextStyle(color: Colors.white30)),
          ],
        ),
      );
    }

    String prettyJson = "";
    bool isJson = false;

    // 🕵️ Try to parse
    if (data is Map || data is List) {
      prettyJson = const JsonEncoder.withIndent('  ').convert(data);
      isJson = true;
    } else if (data is String) {
      try {
        final parsed = jsonDecode(data);
        prettyJson = const JsonEncoder.withIndent('  ').convert(parsed);
        isJson = true;
      } catch (e) {
        prettyJson = data.toString();
      }
    } else {
      prettyJson = data.toString();
    }

    return Stack(
      children: [
        // The Code View
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF282A36), // Background
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: isJson
                ? SelectableText.rich(
              TextSpan(children: _highlightJson(prettyJson)),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.5),
            )
                : SelectableText(
              prettyJson,
              style: const TextStyle(color: Color(0xFFF8F8F2), fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),

        // The Floating Copy Button
        if (showCopy)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              backgroundColor: const Color(0xFFBD93F9),
              child: const Icon(Icons.copy, color: Colors.white),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: prettyJson));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Copied! ✨"),
                    backgroundColor: Color(0xFF44475A),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          )
      ],
    );
  }

  // 🎨 DRACULA SYNTAX HIGHLIGHTER
  List<TextSpan> _highlightJson(String jsonString) {
    final List<TextSpan> spans = [];
    final lines = jsonString.split('\n');

    // Colors
    const keyColor = Color(0xFF8BE9FD); // Cyan
    const stringColor = Color(0xFFF1FA8C); // Yellow/Green
    const numberColor = Color(0xFFBD93F9); // Purple
    const boolColor = Color(0xFFFF79C6); // Pink
    const punctColor = Color(0xFFF8F8F2); // White

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      // Line Number (Optional - adds "Pro" feel)
      spans.add(TextSpan(
        text: "${i + 1}  ",
        style: const TextStyle(color: Color(0xFF6272A4), fontSize: 11), // Comment Color
      ));

      if (line.contains(':')) {
        final parts = line.split(':');
        final keyPart = parts[0];
        final valPart = parts.sublist(1).join(':');

        spans.add(TextSpan(text: keyPart, style: const TextStyle(color: keyColor)));
        spans.add(const TextSpan(text: ':', style: TextStyle(color: punctColor)));
        spans.add(_colorizeValue(valPart, stringColor, numberColor, boolColor, punctColor));
      } else {
        spans.add(TextSpan(text: line, style: const TextStyle(color: punctColor)));
      }
      spans.add(const TextSpan(text: '\n'));
    }
    return spans;
  }

  TextSpan _colorizeValue(String value, Color str, Color num, Color boolC, Color punct) {
    String clean = value;
    String suffix = "";
    if (value.trimRight().endsWith(',')) {
      clean = value.substring(0, value.lastIndexOf(','));
      suffix = ",";
    } else if (value.trimRight().endsWith(']')) {
      // simple fix for inline array closers
    }

    TextStyle style = TextStyle(color: str); // Default String

    if (clean.contains('"')) {
      style = TextStyle(color: str);
    } else if (RegExp(r'^-?\d+(\.\d+)?$').hasMatch(clean.trim())) {
      style = TextStyle(color: num);
    } else if (['true', 'false', 'null'].contains(clean.trim())) {
      style = TextStyle(color: boolC);
    }

    return TextSpan(
      children: [
        TextSpan(text: clean, style: style),
        TextSpan(text: suffix, style: TextStyle(color: punct)),
      ],
    );
  }
}