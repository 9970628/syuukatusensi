// lib/screens/game_screen.dart

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sennsi_app/game/task_battle_game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = TaskBattleGame();

    return Scaffold(
      appBar: AppBar(
        title: const Text('バトル'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: GameWidget(game: game),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flash_on),
              label: const Text('攻撃'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                game.attack();
              },
            ),
          ),
        ],
      ),
    );
  }
}