import 'package:flame/components.dart'; //アニメーション切り替え
import 'package:flame/game.dart'; //ゲーム全体

class Sennsi extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  Sennsi() : super(size: Vector2.all(64)); // キャラのサイズ

  @override
  Future<void> onLoad() async {
    final image1 = await gameRef.images.load('sennsi_walk1.png');
    final image2 = await gameRef.images.load('sennsi_walk2.png');

    animation = SpriteAnimation.spriteList(
      [Sprite(image1), Sprite(image2)],
      stepTime: 0.2, // 0.2秒ごとに切り替え
    );

    position = Vector2(160, 400); // 初期位置
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= 50 * dt; // 上方向に移動
  }
}
