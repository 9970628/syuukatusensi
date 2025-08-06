
import 'package:flutter/material.dart';
import 'package:sennsi_app/config/router.dart';
import 'package:sennsi_app/screens/login_screen.dart';
// task_list_screen.dart ファイルをインポートしてGoalListScreenを使えるようにする
import 'package:sennsi_app/screens/task_list_screen.dart';
import 'package:sennsi_app/screens/calender_screen.dart'; //機能　開発者が作った
import 'package:sennsi_app/widgets/shell.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/models/task.dart';
import 'package:sennsi_app/screens/home_screen.dart';

import 'package:device_preview/device_preview.dart' ;// 起動画面はHomeScreen


Future<void> main() async {
  // Flutterアプリを初期化するための準備
  WidgetsFlutterBinding.ensureInitialized();
  // 日本語の日付書式を使えるように初期化
  await initializeDateFormatting('ja_JP', null);
  
  // アプリケーションを起動
  runApp(

    DevicePreview(
      enabled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => GoalModel(),
        child: const MyApp(),
      ),

    ),
  );
}

// アプリケーションのルート（根っこ）となるウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      builder: DevicePreview.appBuilder,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
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