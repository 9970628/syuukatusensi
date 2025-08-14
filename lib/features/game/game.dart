import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../components/sennsi.dart';
import '../../components/background.dart';
import 'package:flame_audio/flame_audio.dart';

class MyGame extends FlameGame {
  final VoidCallback onFlashComplete;
  final VoidCallback onMoveComplete;

  MyGame({required this.onFlashComplete, required this.onMoveComplete});

  @override
  Future<void> onLoad() async {
    await add(Background());
    await add(
      Sennsi(onFlashComplete: onFlashComplete, onMoveComplete: onMoveComplete),
    );

    await FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.load('audio/bgm.mp3');
    FlameAudio.bgm.play('audio/bgm.mp3');
  }

  @override
  void onDetach() {
    FlameAudio.bgm.stop();
    super.onDetach();
  }
}
