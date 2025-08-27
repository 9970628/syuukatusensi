import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/shared/models/task.dart';

class StageScreen extends StatefulWidget {
  const StageScreen({Key? key}) : super(key: key);

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  void _goToBattle() {
    context.go('/battle');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, gameModel, child) {
        return Scaffold(
          body: Stack(
            children: [
              // 背景
              Positioned.fill(
                child: Image.asset(
                  'assets/images/dungeon_corridor01.png',
                  fit: BoxFit.cover,
                ),
              ),

              // ステージ表示（左上）
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ダンジョン階層: ${gameModel.currentFloor}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 3, color: Colors.black)],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'HP: ${gameModel.playerHP}/${gameModel.playerMaxHP}\nMP: ${gameModel.playerMP}/${gameModel.playerMaxMP}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // コマンドウィンドウ（下部）
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.7),
                  child: ElevatedButton(
                    onPressed: _goToBattle,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.red.withOpacity(0.8),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('${gameModel.currentFloor}階層に挑戦！'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
