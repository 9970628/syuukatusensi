import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart'; // あなたが作った MyGame クラスがここにあると想定

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(game: MyGame()));
}
