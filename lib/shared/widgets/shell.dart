import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Shell extends StatelessWidget {
  final Widget child;

  const Shell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ★★★ 変更点(1)：背景画像を設定するためにStackを使用 ★★★
      body: Stack(
        children: [
          // --- 最背面に配置する背景画像 ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/backgrounds/grid_paper.png"),
                fit: BoxFit.cover,
                opacity: 0.3, // 半透明にしてコンテンツの邪魔にならないように
              ),
            ),
          ),
          // --- メインのコンテンツ（HomeScreenなどがここに入る） ---
          child,
        ],
      ),
      // ★★★ 変更点(2)：タブバーを4つの項目に変更＆アイコンを文具風に ★★★
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // ホーム
            activeIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note), // タスク (ノート)
            activeIcon: Icon(Icons.edit),
            label: 'タスク',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), // カレンダー 
            activeIcon: Icon(Icons.calendar_today),
            label: 'カレンダー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad_outlined), // ゲーム
            activeIcon: Icon(Icons.gamepad),
            label: 'ゲーム',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int index) => _onItemTapped(index, context),
        // タブが4つ以上の場合、以下の設定がないとデザインが崩れる
        type: BottomNavigationBarType.fixed, 
        backgroundColor: Colors.white.withOpacity(0.8), // 背景が透けるように少し透明に
        elevation: 0, // 影を消して背景と馴染ませる
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
      ),
    );
  }

  // 現在のルートパスから、選択中のタブのインデックスを計算する
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/task')) {
      return 1;
    }
    if (location.startsWith('/calendar')) {
      return 2;
    }
    if (location.startsWith('/game')) {
      return 3;
    }
    // デフォルトはホーム
    return 0;
  }

  // タブがタップされたときに、対応するパスに遷移する
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/task');
        break;
      case 2:
        context.go('/calendar');
        break;
      case 3:
        context.go('/game');
        break;
    }
  }
}