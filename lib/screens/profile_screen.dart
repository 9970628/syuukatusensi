import 'package:flutter/material.dart';

import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String name = "勇者";
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

// =======
// class _ProfileScreenState extends State<StatusScreen> {
//   // 編集可能なデータ
//   String _name = '戦士　標（しるべ）';
//   String _selectedGrade = '大学3年';
//   String _jobHuntingPeriod = '残り15週（5週進行）';
  
//   // 編集モードの状態
//   bool _isEditing = false;
  
//   // 学年選択用のコントローラー
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _gradeController = TextEditingController();
  
//   // 学年オプション
//   final List<String> _gradeOptions = [
//     '大学1年',
//     '大学2年',
//     '大学3年',
//     '大学4年',
//     '大学院1年',
//     '大学院2年',
//   ];
// >>>>>>> main

  @override
  void initState() {
    super.initState();
    _loadProfileData();

    _tabController = TabController(length: 1, vsync: this);
// =======
//     _nameController.text = _name;
//     _gradeController.text = _selectedGrade;
//     _updateJobHuntingPeriod();
//     _loadData(); // データを読み込む
// >>>>>>> main
  }

  @override
  void dispose() {

    _tabController.dispose();
    super.dispose();
  }

Future<void> _loadProfileData() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    name = prefs.getString('name') ?? "勇者";
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
        break;;
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



// =======
//     _nameController.dispose();
//     _gradeController.dispose();
//     super.dispose();
//   }

//   void _updateJobHuntingPeriod() {
//     // 現在の日付を取得
//     DateTime now = DateTime.now();
    
//     // 学年に基づいて卒業予定年を計算
//     Map<String, int> gradeToGraduationYear = {
//       '大学1年': now.year + 3, // 現在1年なら3年後に卒業
//       '大学2年': now.year + 2,
//       '大学3年': now.year + 1,
//       '大学4年': now.year,
//       '大学院1年': now.year + 1,
//       '大学院2年': now.year,
//     };
    
//     int graduationYear = gradeToGraduationYear[_selectedGrade] ?? now.year;
    
//     // 就活終了日（4年生の7月末）
//     DateTime jobHuntingEnd = DateTime(graduationYear, 7, 31);
    
//     // 現在から就活終了日までの週数を計算
//     int totalWeeks = jobHuntingEnd.difference(now).inDays ~/ 7;
    
//     // 進行週数（開始から現在まで）
//     // 大学3年生の3月から就活開始と仮定
//     DateTime jobHuntingStart = DateTime(graduationYear - 1, 3, 1);
//     int progressWeeks = now.difference(jobHuntingStart).inDays ~/ 7;
    
//     // 負の値にならないように調整
//     if (totalWeeks < 0) totalWeeks = 0;
//     if (progressWeeks < 0) progressWeeks = 0;
    
//     _jobHuntingPeriod = '残り${totalWeeks}週（${progressWeeks}週進行）';
//   }

//   // データを保存
//   Future<void> _saveData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_name', _name);
//     await prefs.setString('user_grade', _selectedGrade);
//   }

//   // データを読み込み
//   Future<void> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _name = prefs.getString('user_name') ?? '戦士　標（しるべ）';
//       _selectedGrade = prefs.getString('user_grade') ?? '大学3年';
//       _nameController.text = _name;
//       _gradeController.text = _selectedGrade;
//       _updateJobHuntingPeriod();
//     });
//   }

//   void _saveChanges() {
//     // データを保存
//     _saveData();
//     // 保存処理（現在はスナックバーで確認のみ）
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('変更を保存しました')),
//     );
//   }

// >>>>>>> main
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final double screenWidth = size.width;
  final double baseWidth = 390.0; // iPhone 14/15/Plusの中間値
  final double scale = (screenWidth / baseWidth).clamp(0.85, 1.25);
  final double width = screenWidth;

  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      title: Text(
        'プロフィール',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18 * scale,
        ),
      ),
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400, // タブレットでも最大400pxまで
                ),
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
                              color: Colors.black87,
                              letterSpacing: 2 * scale,
                            ),
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                        ElevatedButton(
                          onPressed: _resetData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                              vertical: 8 * scale,
                              horizontal: 16 * scale,
                            ),
                          ),
                          child: Text(
                            "リセット",
                            style: TextStyle(fontSize: 14 * scale),
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                        Divider(color: Colors.blue, thickness: 2 * scale),
                        SizedBox(height: 2 * scale),
                        // 以下、_StatusBadgeや他のWidgetも同様にscaleを渡して調整
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SizedBox(height: 2 * scale),
                          // タスク累計・志望企業
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // タスク累計バッジ
                              _StatusBadge(
                                icon: Icons.task_alt,
                                label: 'タスク',
                                value: '$totalTasks',
                                color: Colors.purple,
                                onAdd: () => _changeStat('totalTasks', 1),
                                onRemove: () => _changeStat('totalTasks', -1),
                                scale: scale,
                              ),
                              const SizedBox(height: 4),
                              // 志望企業バッジ
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 400, // タブレットでも最大400px
                                ),
                                margin: EdgeInsets.symmetric(vertical: width * 0.02),
                                padding: EdgeInsets.all(width * 0.04),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width * 0.04),
                                  border: Border.all(color: Colors.black.withOpacity(0.25)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.35),
                                      blurRadius: width * 0.04,
                                      offset: Offset(0, width * 0.01),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '志望企業',
                                      style: TextStyle(
                                        fontSize: 14 * scale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8 * scale),
                                    Text(
                                      company,
                                      style: TextStyle(
                                        fontSize: 18 * scale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
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
    final badgePadding = width * 0.025; // 画面幅の約2.5%をパディングに
    final badgeRadius = width * 0.04; // 角丸も画面幅に応じて
    

    return Container(
      margin: EdgeInsets.symmetric(vertical: badgePadding * 0.3),
      padding: EdgeInsets.symmetric(vertical: badgePadding * 0.5, horizontal: badgePadding),
      decoration: BoxDecoration(
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