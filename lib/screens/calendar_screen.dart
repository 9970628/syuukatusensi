// lib/screens/calendar_screen.dart

import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
      ),
      body: const Center(
        child: Text(
          'カレンダー機能は現在開発中です。',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}