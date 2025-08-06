import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Background extends SpriteComponent
    with
        HasGameRef<FlameGame> //spritecomponent＝一枚絵
        {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('background.png');
    size = gameRef.size; //ゲーム全体に背景
    position = Vector2.zero(); // 画面全体に表示(左上から固定)
  }
}
