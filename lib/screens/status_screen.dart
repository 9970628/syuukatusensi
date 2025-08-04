// lib/screens/status_screen.dart

import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int level = 1;
  int hp = 100;
  int mp = 30;
  int attack = 10;
  int defense = 5;

  void _levelUp() {
    setState(() {
      level++;
      hp += 20;
      mp += 5;
      attack += 3;
      defense += 2;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // ← 画面全体の背景を白に
    appBar: AppBar(
      title: const Text(
        'ステータス',
        style: TextStyle(color: Colors.black), // ← タイトルを黒文字に
      ),
      backgroundColor: Colors.white, // ← AppBarの背景を白に
      iconTheme: const IconThemeData(color: Colors.black), // ← アイコンも黒に
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.amber,
        labelColor: Colors.black, // ← タブの選択文字色
        unselectedLabelColor: Colors.grey, // ← タブの未選択文字色
        tabs: const [
          Tab(icon: Icon(Icons.person), text: '基本'),
          Tab(icon: Icon(Icons.shield), text: '装備'),
          Tab(icon: Icon(Icons.flash_on), text: 'スキル'),
        ],
      ),
    ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 基本ステータス
          Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/backgrounds/status_screen.jpg',
                fit: BoxFit.cover,
              ),
              Center(
                child: Card(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(24),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '名前: 勇者',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        Text(
                          'レベル: $level',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const Divider(color: Colors.amber),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatusItem(
                              icon: Icons.favorite,
                              label: 'HP',
                              value: '$hp',
                            ),
                            _StatusItem(
                              icon: Icons.bolt,
                              label: 'MP',
                              value: '$mp',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatusItem(
                              icon: Icons.sports_martial_arts,
                              label: '攻撃',
                              value: '$attack',
                            ),
                            _StatusItem(
                              icon: Icons.shield,
                              label: '防御',
                              value: '$defense',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _levelUp,
                          child: const Text('レベルアップ'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 装備
          Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/backgrounds/status_screen.jpg',
                fit: BoxFit.cover,
              ),
              Center(
                child: Card(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(24),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          '装備一覧',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        Divider(color: Colors.blueAccent),
                        ListTile(
                          leading: Icon(
                            Icons.sports_martial_arts,
                            color: Colors.amber,
                          ),
                          title: Text(
                            '武器: 鋼の剣',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.shield, color: Colors.blueAccent),
                          title: Text(
                            '防具: 鉄の鎧',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.star, color: Colors.redAccent),
                          title: Text(
                            'アクセサリ: 力の指輪',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // スキル
          Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/backgrounds/status_screen.jpg',
                fit: BoxFit.cover,
              ),
              Center(
                child: Card(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(24),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'スキル一覧',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        Divider(color: Colors.greenAccent),
                        ListTile(
                          leading: Icon(
                            Icons.local_fire_department,
                            color: Colors.red,
                          ),
                          title: Text(
                            'ファイア',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.healing, color: Colors.green),
                          title: Text('ヒール', style: TextStyle(color: Colors.white)),
                        ),
                        ListTile(
                          leading: Icon(Icons.flash_on, color: Colors.yellow),
                          title: Text(
                            'バッシュ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ステータス項目用ウィジェット
class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 28),
        Text(label, style: const TextStyle(color: Colors.white)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
