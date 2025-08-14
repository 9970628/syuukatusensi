import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Sennsi extends SpriteComponent with HasGameRef {
  final VoidCallback onFlashComplete;
  final VoidCallback onMoveComplete;
  
  Sennsi({required this.onFlashComplete, required this.onMoveComplete});

  @override
  Future<void> onLoad() async {
    // 仮のキャラクター（後で画像に置き換え可能）
    size = Vector2(50, 50);
    position = Vector2(gameRef.size.x / 2, gameRef.size.y / 2);
    paint.color = Colors.orange;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
  }

  @override
  void update(double dt) {
    // 簡単なアニメーション効果
    if (gameRef.currentTime() > 2.0) {
      onFlashComplete();
    }
  }
} 