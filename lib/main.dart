// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/models/task.dart';
import 'package:sennsi_app/screens/home_screen.dart';

Future<void> main() async {
  // Flutterアプリを初期化するための準備
  WidgetsFlutterBinding.ensureInitialized();
  // 日本語の日付書式を使えるように初期化
  await initializeDateFormatting('ja_JP', null);
  
  // アプリケーションを起動
  runApp(
    // アプリ全体でGoalModelを使えるように提供する
    ChangeNotifierProvider(
      create: (context) => GoalModel(),
      child: const MyApp(),
    ),
  );
}

// アプリケーションのルート（根っこ）となるウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // マテリアルデザインのアプリを作成するための基本ウィジェット
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 右上のDEBUGバナーを非表示にする
      title: 'Goal Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      // アプリ起動時に最初に表示する画面
      home: const HomeScreen(),
    );
  }
}