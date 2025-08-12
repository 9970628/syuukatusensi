import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ゲーム'),
      ),
      body: const Center(
        child: Text(
          'ゲーム画面は現在開発中です。',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}