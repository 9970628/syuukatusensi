import 'package:flutter/material.dart';
import 'package:sennsi_app/screens/login_screen.dart';
// task_list_screen.dart ファイルをインポートしてGoalListScreenを使えるようにする
import 'package:sennsi_app/screens/task_list_screen.dart';
import 'package:sennsi_app/screens/calender_screen.dart'; //機能　開発者が作った


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // ★★★ 最初に表示する画面を GoalListScreen に変更 ★★★
      home: const GoalListScreen(),
    );
  }
}