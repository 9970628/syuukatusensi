import 'package:flutter/material.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('戦闘画面')),
      body: Center(child: Text('ここが戦闘画面だよ！')),
    );
  }
}
