// lib/screens/status_screen.dart

import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ステータス'),
        // この画面にはタブバーがないため、戻るボタンが自動で表示されます
      ),
      body: const Center(
        child: Text(
          'ステータス画面は現在開発中です。',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}