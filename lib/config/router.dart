import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sennsi_app/features/game/game.dart';
import 'package:sennsi_app/features/calendar/calender_screen.dart';
import 'package:sennsi_app/features/home/home_screen.dart';
import 'package:sennsi_app/features/auth/login_screen.dart';
import 'package:sennsi_app/features/profile/status_screen.dart';
import 'package:sennsi_app/features/tasks/task_list_screen.dart';
import 'package:sennsi_app/features/game/game_screen.dart';
import 'package:sennsi_app/features/profile/profile_screen.dart';
import 'package:sennsi_app/features/profile/profile_data_input_screen.dart';
import '../shared/widgets/shell.dart';

import 'package:sennsi_app/features/game/battle/battle_screen.dart';

import 'package:flame/game.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/calendar', builder: (context, state) => CalendarScreen()),

    GoRoute(
      path: '/status',
      pageBuilder: (context, state) =>
          MaterialPage(child: const StatusScreen()),
    ),

    // 認証が必要なルート
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => Shell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const HomeScreen()),
        ),
        GoRoute(
          path: '/task',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const GoalListScreen()),

        ),
        GoRoute(
          path: '/input',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const ProfileDataInputScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const ProfileScreen()),

        ),
        GoRoute(
          path: '/status',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const StatusScreen()),
        ),
        GoRoute(
          path: '/game',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const GameScreen()),
        ),
        GoRoute(
          path: '/battle',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const BattleScreen()),

        ),
      ],
    ),
    // 認証が不要なルート
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen(),
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
