import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart'; // 追加

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen>
    with SingleTickerProviderStateMixin {
  // --- フィールド ---
  late TabController _tabController;
  String name = "未設定";
  String company = "未設定";
  int level = 1;
  int hp = 100;
  int mp = 30;
  int grade = 1;
  int weeksLeft = 12;
  int totalTasks = 0;
  int defeatCount = 0;
  int currentFloor = 1;
  double progress = 0.0;
  int exp = 0;
  int get nextExp => (100 * pow(1.5, level - 1)).toInt();

  void _resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name'); // 名前をリセット
    await prefs.remove('grade'); // 学年をリセット
    await prefs.remove('company'); // 志望企業をリセット
    await prefs.remove('date'); // 日付をリセット
  }

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

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "未設定";
      grade = prefs.getInt('grade') ?? 1;
      company = prefs.getString('company') ?? "未設定";

      DateTime today = DateTime.now();
      int graduationYear = today.year + (5 - grade); // 学年に応じて卒業年度計算
      DateTime graduationDate = DateTime(graduationYear, 4, 1);

      int daysLeft = graduationDate.difference(today).inDays;
      weeksLeft = (daysLeft / 7).ceil(); // 切り上げ計算で残り週を算出
    });
  }

  void _changeStat(String stat, int delta) {
    setState(() {
      switch (stat) {
        case 'grade':
          grade = max(1, grade + delta);
          // 学年変更に応じて残り週を再計算
          DateTime today = DateTime.now();
          int graduationYear = today.year + (5 - grade);
          DateTime graduationDate = DateTime(graduationYear, 4, 1);

          int daysLeft = graduationDate.difference(today).inDays;
          weeksLeft = (daysLeft / 7).ceil();
          break;
        case 'weeksLeft':
          weeksLeft = max(0, weeksLeft + delta);
          break;
        case 'hp':
          hp = max(0, hp + delta);
          break;
        case 'mp':
          mp = max(0, mp + delta);
          break;
          ;
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
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double baseWidth = 390.0;
    final double scale = (screenWidth / baseWidth).clamp(0.85, 1.25);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/home'); // ホームに遷移
          },
        ),
        title: const Text('ステータス', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              child: Text(
                '基本',
                style: TextStyle(fontSize: 14 * scale),
              ),
            ),
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
                  constraints: const BoxConstraints(maxWidth: 400), // タブレット対策
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(0),
                      borderRadius: BorderRadius.circular(24 * scale),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 16 * scale,
                          offset: Offset(0, 8 * scale),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16 * scale,
                      horizontal: 16 * scale,
                    ),
                    width: 300 * scale,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 26 * scale,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2 * scale,
                              ),
                            ),
                          ),
                          SizedBox(height: 2 * scale),
                          Divider(color: Colors.blue, thickness: 2 * scale),
                          SizedBox(height: 2 * scale),
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
                                scale: scale,
                              ),
                              SizedBox(width: 16 * scale),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0 * scale),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '経験値: $exp / $nextExp',
                                        style: TextStyle(
                                          fontSize: 12 * scale,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      LinearProgressIndicator(
                                        value: exp / nextExp,
                                        backgroundColor: const Color.fromARGB(31, 0, 0, 0),
                                        color: Colors.blue,
                                        minHeight: 6 * scale,
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
                            children: [
                              Expanded(
                                child: _StatusBadge(
                                  icon: Icons.favorite,
                                  label: 'HP',
                                  value: '$hp',
                                  color: Colors.redAccent,
                                  onAdd: () => _changeStat('hp', 10),
                                  onRemove: () => _changeStat('hp', -10),
                                  scale: scale,
                                ),
                              ),
                              SizedBox(width: 16 * scale),
                              Expanded(
                                child: _StatusBadge(
                                  icon: Icons.bolt,
                                  label: 'MP',
                                  value: '$mp',
                                  color: Colors.blue,
                                  onAdd: () => _changeStat('mp', 5),
                                  onRemove: () => _changeStat('mp', -5),
                                  scale: scale,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * scale),
                          // 学年・就活期間
                          Row(
                            children: [
                              Expanded(
                                child: _StatusBadge(
                                  icon: Icons.school,
                                  label: '学年',
                                  value: '$grade',
                                  color: Colors.green,
                                  onAdd: () => _changeStat('grade', 1),
                                  onRemove: () => _changeStat('grade', -1),
                                  scale: scale,
                                ),
                              ),
                              SizedBox(width: 16 * scale),
                              Expanded(
                                child: _StatusBadge(
                                  icon: Icons.calendar_today,
                                  label: '残り週',
                                  value: '$weeksLeft',
                                  color: Colors.orange,
                                  onAdd: () => _changeStat('weeksLeft', 1),
                                  onRemove: () => _changeStat('weeksLeft', -1),
                                  scale: scale,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * scale),
                          // タスク累計・討伐数
                          Row(
                            children: [
                              Expanded(
                                child: _StatusBadge(
                                  icon: Icons.task_alt,
                                  label: 'タスク',
                                  value: '$totalTasks',
                                  color: Colors.purple,
                                  onAdd: () => _changeStat('totalTasks', 1),
                                  onRemove: () => _changeStat('totalTasks', -1),
                                  scale: scale,
                                ),
                              ),
                              SizedBox(width: 16 * scale),
                              Expanded(
                                child: _StatusBadge(
                                  icon: Icons.sports_kabaddi,
                                  label: '討伐',
                                  value: '$defeatCount',
                                  color: Colors.brown,
                                  onAdd: () => _changeStat('defeatCount', 1),
                                  onRemove: () => _changeStat('defeatCount', -1),
                                  scale: scale,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * scale),
                          // 現在地・志望企業
                          Row(
                            children: [
                              Expanded(
                                child: _StatusBadge(
                                  icon: Icons.location_on,
                                  label: '階',
                                  value: '$currentFloor',
                                  color: Colors.teal,
                                  onAdd: () => _changeStat('currentFloor', 1),
                                  onRemove: () => _changeStat('currentFloor', -1),
                                  scale: scale,
                                ),
                              ),
                            ],
                          ),                          
                        ],
                      ),
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
  final double scale;

  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onAdd,
    required this.onRemove,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final badgePadding = width * 0.025;
    final badgeRadius = width * 0.04;

    return Container(
      margin: EdgeInsets.symmetric(vertical: badgePadding * 0.3),
      padding: EdgeInsets.symmetric(vertical: badgePadding * 0.5, horizontal: badgePadding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
        borderRadius: BorderRadius.circular(badgeRadius),
        border: Border.all(color: Colors.black.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.35),
            blurRadius: badgeRadius,
            offset: Offset(0, badgeRadius * 0.25),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20 * scale),
          SizedBox(width: 8 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 2 * scale),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Row(
            // =======
            //         title: Row(
            //           children: [
            //             Text('👑', style: TextStyle(fontSize: 20)),
            //             SizedBox(width: 8),
            //             Text('就活戦士ステータス画面', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //           ],
            //         ),
            //         backgroundColor: Colors.white,
            //         foregroundColor: Colors.black,
            //         elevation: 1,
            //         actions: [
            //           IconButton(
            //             icon: Icon(_isEditing ? Icons.save : Icons.edit),
            //             onPressed: () {
            //               setState(() {
            //                 if (_isEditing) {
            //                   // 保存処理
            //                   _saveChanges();
            //                 }
            //                 _isEditing = !_isEditing;
            //               });
            //             },
            //           ),
            //         ],
            //       ),
            //       body: SingleChildScrollView(
            //         padding: EdgeInsets.all(16),
            //         child: Column(
            //           children: [
            //             // キャラクター情報セクション
            //             _buildSection(
            //               icon: '🏃‍♂️',
            //               title: 'キャラ立ち絵',
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   _buildEditableInfoRow('名前', _name, (value) {
            //                     if (_isEditing) {
            //                       setState(() {
            //                         _name = value;
            //                       });
            //                       // 名前が変更されたら自動保存
            //                       _saveData();
            //                     }
            //                   }),
            //                   SizedBox(height: 12),
            //                   _buildInfoRow('レベル', 'Lv.3　（勇者見習い）'),
            //                   SizedBox(height: 12),
            //                   _buildInfoRow('HP / MP', '102 / 60'),
            //                   SizedBox(height: 12),
            //                   _buildGradeSelectionRow(),
            //                   SizedBox(height: 12),
            //                   _buildInfoRow('就活期間', _jobHuntingPeriod),
            //                 ],
            //               ),
            //             ),

            //             SizedBox(height: 16),

            //             // 装備・スキルセクション
            //             _buildSection(
            //               icon: '🛡️',
            //               title: '装備・スキル',
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text('• スーツ（Lv2）＋おまもり', style: TextStyle(fontSize: 14)),
            //                   SizedBox(height: 8),
            //                   Text('• スキル　：Lv2「自己PR」', style: TextStyle(fontSize: 14)),
            //                   SizedBox(height: 8),
            //                   Text('• SP残り　：1pt', style: TextStyle(fontSize: 14)),
            //                   SizedBox(height: 12),
            //                   Text('ー スキル履歴 ー', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            //                   SizedBox(height: 8),
            //                   Text('Lv2：自己PR（6/10）', style: TextStyle(fontSize: 14)),
            //                   SizedBox(height: 8),
            //                   Text('Lv3：逆質問の極意（6/17）', style: TextStyle(fontSize: 14)),
            //                 ],
            //               ),
            //             ),

            //             SizedBox(height: 16),

            //             // タスク&戦歴セクション
            //             _buildSection(
            //               icon: '📝',
            //               title: 'タスク&戦歴',
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   _buildInfoRow('タスク累計', '28件'),
            //                   SizedBox(height: 8),
            //                   _buildInfoRow('今週達成', '3件（+2マス）'),
            //                   SizedBox(height: 12),
            //                   _buildInfoRow('討伐数', '6体'),
            //                   SizedBox(height: 8),
            //                   Text('ー 討伐履歴 ー', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            //                   SizedBox(height: 8),
            //                   Text('• こわがり ×2', style: TextStyle(fontSize: 14)),
            //                   SizedBox(height: 4),
            //                   Text('• なまけもの ×1', style: TextStyle(fontSize: 14)),
            //                   SizedBox(height: 4),
            //                   Text('• しんぱい ×3', style: TextStyle(fontSize: 14)),
            //                 ],
            //               ),
            //             ),

            //             SizedBox(height: 16),

            //             // 現在地セクション
            //             _buildSection(
            //               icon: '🏢',
            //               title: '現在地・5F / 15F（会社D）',
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   SizedBox(height: 8),
            //                   Row(
            //                     children: [
            //                       Text('🔄', style: TextStyle(fontSize: 16)),
            //                       SizedBox(width: 8),
            //                       Text('進歩：', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            //                       SizedBox(width: 8),
            //                       Expanded(
            //                         child: _buildProgressBar(0.33),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(height: 8),
            //                   Text('33%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   }

            //   Widget _buildSection({required String icon, required String title, required Widget child}) {
            //     return Container(
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(8),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.2),
            //             spreadRadius: 1,
            //             blurRadius: 3,
            //             offset: Offset(0, 2),
            //           ),
            //         ],
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Container(
            //             width: double.infinity,
            //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //             decoration: BoxDecoration(
            //               border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 2)),
            //             ),
            //             child: Row(
            //               children: [
            //                 Text(icon, style: TextStyle(fontSize: 18)),
            //                 SizedBox(width: 8),
            //                 Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            //               ],
            //             ),
            //           ),
            //           Padding(
            //             padding: EdgeInsets.all(16),
            //             child: child,
            //           ),
            //         ],
            //       ),
            //     );
            //   }

            //   Widget _buildInfoRow(String label, String value) {
            //     return Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         SizedBox(
            //           width: 80,
            //           child: Text(
            //             label,
            //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            //           ),
            //         ),
            //         Text('：', style: TextStyle(fontSize: 14)),
            //         Expanded(
            //           child: Text(
            //             value,
            //             style: TextStyle(fontSize: 14),
            //           ),
            //         ),
            //       ],
            //     );
            //   }

            //   Widget _buildEditableInfoRow(String label, String value, Function(String) onValueChanged) {
            //     return Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         SizedBox(
            //           width: 80,
            //           child: Text(
            //             label,
            //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            //           ),
            //         ),
            //         Text('：', style: TextStyle(fontSize: 14)),
            //         Expanded(
            //           child: _isEditing
            //             ? TextField(
            //                 controller: label == '名前' ? _nameController : null,
            //                 style: TextStyle(fontSize: 14),
            //                 onChanged: onValueChanged,
            //                 decoration: InputDecoration(
            //                   border: OutlineInputBorder(),
            //                   contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //                 ),
            //               )
            //             : Text(
            //                 value,
            //                 style: TextStyle(fontSize: 14),
            //               ),
            //         ),
            //       ],
            //     );
            //   }

            //   Widget _buildProgressBar(double progress) {
            //     return Container(
            //       height: 20,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black, width: 1),
            //         borderRadius: BorderRadius.circular(2),
            //       ),
            //       child: Stack(
            //         children: [
            //           Container(
            //             width: double.infinity,
            //             height: double.infinity,
            //             child: Row(
            //               children: List.generate(8, (index) {
            //                 bool isFilled = index < (progress * 8).floor();
            //                 return Expanded(
            //                   child: Container(
            //                     margin: EdgeInsets.all(1),
            //                     decoration: BoxDecoration(
            //                       color: isFilled ? Colors.black : Colors.white,
            //                     ),
            //                   ),
            //                 );
            //               }),
            //             ),
            // >>>>>>> main
          ),
        ],
      ),
    );
  }

  // Widget _buildGradeSelectionRow() {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         width: 80,
  //         child: Text(
  //           '学年',
  //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //         ),
  //       ),
  //       Text('：', style: TextStyle(fontSize: 14)),
  //       Expanded(
  //         child: DropdownButtonFormField<String>(
  //           value: _selectedGrade,
  //           decoration: InputDecoration(
  //             border: OutlineInputBorder(),
  //           ),
  //           items: _gradeOptions.map((grade) {
  //             return DropdownMenuItem(
  //               value: grade,
  //               child: Text(grade),
  //             );
  //           }).toList(),
  //           onChanged: _isEditing ? (String? newValue) {
  //             if (newValue != null) {
  //               setState(() {
  //                 _selectedGrade = newValue;
  //                 _updateJobHuntingPeriod();
  //               });
  //               // 学年が変更されたら自動保存
  //               _saveData();
  //             }
  //           } : null,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
