import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flash_effect.dart';
import 'package:flutter/foundation.dart';

class Sennsi extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  final VoidCallback onFlashComplete;
  final VoidCallback onMoveComplete;

  bool moving = true;
  bool flashTriggered = false;

  Sennsi({required this.onFlashComplete, required this.onMoveComplete})
    : super(size: Vector2.all(128));

  @override
  Future<void> onLoad() async {
    final image1 = await gameRef.images.load('sennsi_walk1.png');
    final image2 = await gameRef.images.load('sennsi_walk2.png');

    animation = SpriteAnimation.spriteList([
      Sprite(image1),
      Sprite(image2),
    ], stepTime: 0.2);

    position = Vector2(gameRef.size.x / 2 - size.x / 2, 700);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (moving && position.y > 90) {
      position.y -= 50 * dt;
    } else if (moving) {
      moving = false;

      onMoveComplete();

      if (!flashTriggered) {
        flashTriggered = true;
        gameRef.add(FlashEffect(onFlashComplete: onFlashComplete));
      }
    }
  }
}
