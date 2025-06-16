
import 'package:flutter/material.dart';
import 'package:sennsi_app/screens/login_screen.dart';
// task_list_screen.dart ファイルをインポートしてGoalListScreenを使えるようにする
import 'package:sennsi_app/screens/task_list_screen.dart';
import 'package:sennsi_app/screens/calender_screen.dart'; //機能　開発者が作った


import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/models/task.dart';
import 'package:sennsi_app/screens/home_screen.dart'; // 起動画面はHomeScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP', null);
  runApp(
    ChangeNotifierProvider(
      create: (context) => GoalModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      // ★★★ 最初に表示する画面をHomeScreenに設定 ★★★
      home: const HomeScreen(),
    );
  }
}