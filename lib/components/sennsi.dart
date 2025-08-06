import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flash_effect.dart';

class Sennsi extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  bool moving = true; // 移動中かどうか
  bool flashTriggered = false; // フラッシュしたかどうか

  Sennsi() : super(size: Vector2.all(128));

  @override
  Future<void> onLoad() async {
    final image1 = await gameRef.images.load('sennsi_walk1.png');
    final image2 = await gameRef.images.load('sennsi_walk2.png');

    animation = SpriteAnimation.spriteList([
      Sprite(image1),
      Sprite(image2),
    ], stepTime: 0.2);

    position = Vector2(450, 700);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (moving && position.y > 90) {
      position.y -= 50 * dt;
    } else if (moving) {
      // ここで止まったことを検知
      moving = false;

      if (!flashTriggered) {
        flashTriggered = true;
        gameRef.add(FlashEffect()); // フラッシュを発動
      }
    }
  }
}
