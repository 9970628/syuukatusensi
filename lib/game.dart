import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/sennsi.dart';
import 'components/background.dart';
import 'package:flame_audio/flame_audio.dart';

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await add(Background());
    await add(Sennsi());

    WidgetsFlutterBinding.ensureInitialized();
    await FlameAudio.bgm.initialize(); // BGM初期化（必須）
    await FlameAudio.audioCache.load('audio/bgm.mp3'); // BGMを事前読み込み
    FlameAudio.bgm.play('audio/bgm.mp3'); // BGM再生（ループ）
  }

  @override
  void onDetach() {
    FlameAudio.bgm.stop(); // ゲーム終了時にBGM停止
    super.onDetach();
  }
}
