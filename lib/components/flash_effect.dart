import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart'; // VoidCallbackのために必要

class FlashEffect extends PositionComponent with HasGameRef<FlameGame> {
  double opacity = 0.0;
  bool flashingIn = true;
  final double speed = 3.0;

  final VoidCallback onFlashComplete;
  bool _completed = false;

  FlashEffect({required this.onFlashComplete}) : super(size: Vector2.zero());

  @override
  Future<void> onLoad() async {
    // 画面サイズに合わせる
    size = gameRef.size;
    position = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Color.fromRGBO(255, 255, 255, opacity);
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (flashingIn) {
      opacity += speed * dt;
      if (opacity >= 1.0) {
        opacity = 1.0;
        flashingIn = false;
      }
    } else {
      opacity -= speed * dt;
      if (opacity <= 0.0 && !_completed) {
        opacity = 0.0;
        _completed = true;
        onFlashComplete();
        removeFromParent();
      }
    }
  }
}
