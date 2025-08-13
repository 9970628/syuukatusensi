import 'package:flutter/material.dart';

class StageScreen extends StatefulWidget {
  const StageScreen({Key? key}) : super(key: key);

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  int stage = 1;

  void _clearStage() //階層＋
  {
    setState(() {
      stage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景
          Positioned.fill(
            child: Image.asset(
              'images/dungeon_corridor01.png',
              fit: BoxFit.cover,
            ),
          ),

          // ステージ表示（左上）
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'ダンジョン階層: $stage',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 3, color: Colors.black)],
                ),
              ),
            ),
          ),

          /* キャラ配置（敵：右上 / 主人公：左下）
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 80, right: 20),
              child: Image.asset('images/enemy.png', width: 120),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 140, left: 20),
              child: Image.asset('images/hero.png', width: 100),
            ),
          ),*/

          // コマンドウィンドウ（下部）
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.7),
              child: ElevatedButton(
                onPressed: _clearStage,
                child: const Text('クリア！ 次の階層へ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
