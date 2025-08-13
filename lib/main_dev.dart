import 'package:flutter/material.dart';
import 'screens/game_screen.dart'; // ゲーム画面を呼ぶ

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const GameScreen());
  }
}
