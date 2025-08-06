import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:ui';

class FlashEffect extends PositionComponent with HasGameRef<FlameGame> {
  double opacity = 0.0;
  bool flashingIn = true;
  double speed = 3.0;

  FlashEffect() : super(size: Vector2.all(1000));

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
      if (opacity <= 0.0) {
        opacity = 0.0;
        removeFromParent();
      }
    }
  }
}
