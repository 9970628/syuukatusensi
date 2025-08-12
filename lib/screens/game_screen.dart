
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:sennsi_app/screens/battle_screen.dart';
import '../game.dart'; // MyGame クラスがある場所

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool flashFinished = false;
  bool enteredDungeon = false;

  void onFlashComplete() {
    setState(() {
      flashFinished = true;
    });
    // ここでは画面遷移は行わず、ボタン表示のみ制御
  }

  void enterDungeon() {
    if (!enteredDungeon) {
      setState(() {
        enteredDungeon = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BattleScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          GameWidget(
            game: MyGame(
              onFlashComplete: onFlashComplete,
              onMoveComplete: () {
                // ここでは何もしない
              },
            ),
          ),
          if (!enteredDungeon)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: enterDungeon,
                child: const Text('今すぐダンジョンに入る'),
              ),
            ),
        ],
      ),
    );
  }
}

