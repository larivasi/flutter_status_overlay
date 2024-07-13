import 'package:flutter/material.dart';
import 'package:flutter_status_overlay/flutter_status_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StatusOverlay Example')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              'Show Success Status',
              StatusType.success,
              'Success',
              'This is a success message',
            ),
            const SizedBox(height: 15),
            _buildButton(
              context,
              'Show Error Status',
              StatusType.error,
              'Error',
              'This is an error message',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, StatusType type, String title, String message) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(text),
        onPressed: () {
          StatusOverlay.show(
            context,
            title: title,
            message: message,
            type: type,
            duration: const Duration(seconds: 3),
          );
        },
      ),
    );
  }
}
