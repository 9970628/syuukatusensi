import 'package:flutter/material.dart';
import 'dart:math';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String name = "勇者";
  int level = 1;
  int hp = 100;
  int mp = 30;
  int grade = 3;
  int weeksLeft = 12;
  int totalTasks = 0;
  int defeatCount = 0;
  int currentFloor = 1;
  double progress = 0.0;
  int exp = 0;
  int get nextExp => (100 * pow(1.5, level - 1)).toInt();

  void _gainExp(int amount) {
    setState(() {
      exp += amount;
      while (exp >= nextExp) {
        exp -= nextExp;
        level++;
        hp += 20;
        mp += 5;
      }
    });
  }

  void _changeStat(String stat, int delta) {
    setState(() {
      switch (stat) {
        case 'hp':
          hp = max(0, hp + delta);
          break;
        case 'mp':
          mp = max(0, mp + delta);
          break;
        case 'grade':
          grade = max(1, grade + delta);
          break;
        case 'weeksLeft':
          weeksLeft = max(0, weeksLeft + delta);
          break;
        case 'totalTasks':
          totalTasks = max(0, totalTasks + delta);
          break;
        case 'defeatCount':
          defeatCount = max(0, defeatCount + delta);
          break;
        case 'currentFloor':
          currentFloor = max(1, currentFloor + delta);
          break;
        case 'progress':
          progress = (progress + delta).clamp(0, 100);
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ステータス',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: '基本'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/backgrounds/status_screen.jpg',
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment(0, 0.05),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Divider(color: Colors.blue, thickness: 2),
                        const SizedBox(height: 2),
                        // レベル・経験値
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusBadge(
                              icon: Icons.star,
                              label: 'Lv',
                              value: '$level',
                              color: Colors.blue,
                              onAdd: () => setState(() => level++),
                              onRemove: () => setState(() => level = max(1, level - 1)),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 120, // widthを他の_StatusBadgeと合わせる
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '経験値: $exp / $nextExp',
                                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                                    ),
                                    LinearProgressIndicator(
                                      value: exp / nextExp,
                                      backgroundColor: const Color.fromARGB(31, 0, 0, 0),
                                      color: Colors.blue,
                                      minHeight: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Divider(color: Colors.blue),
                        // HP/MP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusBadge(
                              icon: Icons.favorite,
                              label: 'HP',
                              value: '$hp',
                              color: Colors.redAccent,
                              onAdd: () => _changeStat('hp', 10),
                              onRemove: () => _changeStat('hp', -10),
                            ),
                            const SizedBox(width: 16),
                            _StatusBadge(
                              icon: Icons.bolt,
                              label: 'MP',
                              value: '$mp',
                              color: Colors.blue,
                              onAdd: () => _changeStat('mp', 5),
                              onRemove: () => _changeStat('mp', -5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 学年・就活期間
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusBadge(
                              icon: Icons.school,
                              label: '学年',
                              value: '$grade',
                              color: Colors.green,
                              onAdd: () => _changeStat('grade', 1),
                              onRemove: () => _changeStat('grade', -1),
                            ),
                            const SizedBox(width: 16),
                            _StatusBadge(
                              icon: Icons.calendar_today,
                              label: '残り週',
                              value: '$weeksLeft',
                              color: Colors.orange,
                              onAdd: () => _changeStat('weeksLeft', 1),
                              onRemove: () => _changeStat('weeksLeft', -1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // タスク累計・討伐数
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusBadge(
                              icon: Icons.task_alt,
                              label: 'タスク',
                              value: '$totalTasks',
                              color: Colors.purple,
                              onAdd: () => _changeStat('totalTasks', 1),
                              onRemove: () => _changeStat('totalTasks', -1),
                            ),
                            const SizedBox(width: 16),
                            _StatusBadge(
                              icon: Icons.sports_kabaddi,
                              label: '討伐',
                              value: '$defeatCount',
                              color: Colors.brown,
                              onAdd: () => _changeStat('defeatCount', 1),
                              onRemove: () => _changeStat('defeatCount', -1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 現在地・進歩
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusBadge(
                              icon: Icons.location_on,
                              label: '階',
                              value: '$currentFloor',
                              color: Colors.teal,
                              onAdd: () => _changeStat('currentFloor', 1),
                              onRemove: () => _changeStat('currentFloor', -1),
                            ),
                            const SizedBox(width: 16),
                            _StatusBadge(
                              icon: Icons.trending_up,
                              label: '進歩',
                              value: '${progress.toStringAsFixed(1)}%',
                              color: Colors.indigo,
                              onAdd: () => _changeStat('progress', 5),
                              onRemove: () => _changeStat('progress', -5),
                            ),
                          ],
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

// ステータスバッジ用ウィジェット
class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, 
      margin: const EdgeInsets.symmetric(vertical: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0), // 白背景に戻し、見やすくする
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // テキストとボタンを両端に配置
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  color: Colors.black54,
                  padding: EdgeInsets.zero,
                  onPressed: onRemove,
                  tooltip: '-',
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  color: Colors.black54,
                  padding: EdgeInsets.zero,
                  onPressed: onAdd,
                  tooltip: '+',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}