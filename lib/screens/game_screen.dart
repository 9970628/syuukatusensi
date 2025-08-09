
import 'package:go_router/go_router.dart';

// lib/screens/game_screen.dart

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sennsi_app/game/task_battle_game.dart';


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
            'assets/images/backgrounds/tmp.jpg', // 画像パス(今は仮で置いてます)  pubspec.yaml , assets にも変更・追加を加えてください
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
// =======
//     final game = TaskBattleGame();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('バトル'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: GameWidget(game: game),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.flash_on),
//               label: const Text('攻撃'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//               onPressed: () {
//                 game.attack();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// >>>>>>> main
