import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sennsi_app/screens/calender_screen.dart';
import 'package:sennsi_app/screens/home_screen.dart';
import 'package:sennsi_app/screens/login_screen.dart';
import 'package:sennsi_app/screens/status_screen.dart';
import 'package:sennsi_app/screens/task_list_screen.dart';
import '../widgets/shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(path:'/calendar',
    builder: (context, state)=> CalendarScreen(),
     ),
    // 認証が必要なルート
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => Shell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state)=> NoTransitionPage(
            child: const HomeScreen() )
        ),
        GoRoute(
          path: '/task',
          pageBuilder: (context, state)=> NoTransitionPage(
            child: const GoalListScreen() )
        ),
        GoRoute(
          path: '/status',
          pageBuilder: (context, state)=> NoTransitionPage(
            child: const StatusScreen())
        ),
      ],
    ),
    // 認証が不要なルート
    GoRoute(
      path: '/login',
      builder: (context, state) => const GoalListScreen(),
    ),
  ],
  // リダイレクト処理
  redirect: (context, state) async {
    //final isLoggedIn = await LoginManager.isLoggedIn();
    final isLoginRoute = state.matchedLocation == '/login';

    // if (!isLoggedIn && !isLoginRoute) {
    //   return '/login';
    // }

    // if (isLoggedIn && isLoginRoute) {
    //   return '/';
    // }

    return null;
  },
);