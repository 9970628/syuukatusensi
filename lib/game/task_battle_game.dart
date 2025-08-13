// lib/game/task_battle_game.dart

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class TaskBattleGame extends FlameGame {
  late SpriteComponent player;
  late SpriteComponent enemy;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ★★★ パスは「ファイル名のみ」を指定するのが正しいです ★★★
    player = SpriteComponent()
      ..sprite = await Sprite.load('player.png')
      ..size = Vector2(100, 100)
      ..anchor = Anchor.center;
    add(player);

    // ★★★ パスは「ファイル名のみ」を指定するのが正しいです ★★★
    enemy = SpriteComponent()
      ..sprite = await Sprite.load('enemy.png')
      ..size = Vector2(100, 100)
      ..anchor = Anchor.center;
    add(enemy);

    _resetPositions();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) {
      _resetPositions();
    }
  }

  void _resetPositions() {
    if (size.x > 0 && size.y > 0) {
      player.position = Vector2(size.x / 4, size.y / 2);
      enemy.position = Vector2(size.x * 3 / 4, size.y / 2);
    }
  }

  void attack() {
    print('攻撃コマンドが実行されました！');
  }
}