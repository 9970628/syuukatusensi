import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ダンジョン'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ← 戻るアイコン
          onPressed: () => context.go('/home'), // ← ホーム画面に戻る処理
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/backgrounds/tmp.jpg', // 画像パス
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              padding: const EdgeInsets.all(24),
              child: const Text(
                'ここがダンジョン画面です',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}