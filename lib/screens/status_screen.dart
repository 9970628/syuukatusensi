// lib/screens/status_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // 編集可能なデータ
  String _name = '戦士　標（しるべ）';
  String _selectedGrade = '大学3年';
  String _jobHuntingPeriod = '残り15週（5週進行）';
  
  // 編集モードの状態
  bool _isEditing = false;
  
  // 学年選択用のコントローラー
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  
  // 学年オプション
  final List<String> _gradeOptions = [
    '大学1年',
    '大学2年',
    '大学3年',
    '大学4年',
    '大学院1年',
    '大学院2年',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _gradeController.text = _selectedGrade;
    _updateJobHuntingPeriod();
    _loadData(); // データを読み込む
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _updateJobHuntingPeriod() {
    // 現在の日付を取得
    DateTime now = DateTime.now();
    
    // 学年に基づいて卒業予定年を計算
    Map<String, int> gradeToGraduationYear = {
      '大学1年': now.year + 3, // 現在1年なら3年後に卒業
      '大学2年': now.year + 2,
      '大学3年': now.year + 1,
      '大学4年': now.year,
      '大学院1年': now.year + 1,
      '大学院2年': now.year,
    };
    
    int graduationYear = gradeToGraduationYear[_selectedGrade] ?? now.year;
    
    // 就活終了日（4年生の7月末）
    DateTime jobHuntingEnd = DateTime(graduationYear, 7, 31);
    
    // 現在から就活終了日までの週数を計算
    int totalWeeks = jobHuntingEnd.difference(now).inDays ~/ 7;
    
    // 進行週数（開始から現在まで）
    // 大学3年生の3月から就活開始と仮定
    DateTime jobHuntingStart = DateTime(graduationYear - 1, 3, 1);
    int progressWeeks = now.difference(jobHuntingStart).inDays ~/ 7;
    
    // 負の値にならないように調整
    if (totalWeeks < 0) totalWeeks = 0;
    if (progressWeeks < 0) progressWeeks = 0;
    
    _jobHuntingPeriod = '残り${totalWeeks}週（${progressWeeks}週進行）';
  }

  // データを保存
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _name);
    await prefs.setString('user_grade', _selectedGrade);
  }

  // データを読み込み
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? '戦士　標（しるべ）';
      _selectedGrade = prefs.getString('user_grade') ?? '大学3年';
      _nameController.text = _name;
      _gradeController.text = _selectedGrade;
      _updateJobHuntingPeriod();
    });
  }

  void _saveChanges() {
    // データを保存
    _saveData();
    // 保存処理（現在はスナックバーで確認のみ）
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('変更を保存しました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Text('👑', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text('就活戦士ステータス画面', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  // 保存処理
                  _saveChanges();
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // キャラクター情報セクション
            _buildSection(
              icon: '🏃‍♂️',
              title: 'キャラ立ち絵',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableInfoRow('名前', _name, (value) {
                    if (_isEditing) {
                      setState(() {
                        _name = value;
                      });
                      // 名前が変更されたら自動保存
                      _saveData();
                    }
                  }),
                  SizedBox(height: 12),
                  _buildInfoRow('レベル', 'Lv.3　（勇者見習い）'),
                  SizedBox(height: 12),
                  _buildInfoRow('HP / MP', '102 / 60'),
                  SizedBox(height: 12),
                  _buildGradeSelectionRow(),
                  SizedBox(height: 12),
                  _buildInfoRow('就活期間', _jobHuntingPeriod),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // 装備・スキルセクション
            _buildSection(
              icon: '🛡️',
              title: '装備・スキル',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• スーツ（Lv2）＋おまもり', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text('• スキル　：Lv2「自己PR」', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text('• SP残り　：1pt', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 12),
                  Text('ー スキル履歴 ー', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Lv2：自己PR（6/10）', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text('Lv3：逆質問の極意（6/17）', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // タスク&戦歴セクション
            _buildSection(
              icon: '📝',
              title: 'タスク&戦歴',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('タスク累計', '28件'),
                  SizedBox(height: 8),
                  _buildInfoRow('今週達成', '3件（+2マス）'),
                  SizedBox(height: 12),
                  _buildInfoRow('討伐数', '6体'),
                  SizedBox(height: 8),
                  Text('ー 討伐履歴 ー', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('• こわがり ×2', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 4),
                  Text('• なまけもの ×1', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 4),
                  Text('• しんぱい ×3', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // 現在地セクション
            _buildSection(
              icon: '🏢',
              title: '現在地・5F / 15F（会社D）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text('🔄', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Text('進歩：', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildProgressBar(0.33),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('33%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String icon, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 2)),
            ),
            child: Row(
              children: [
                Text(icon, style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Text('：', style: TextStyle(fontSize: 14)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableInfoRow(String label, String value, Function(String) onValueChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Text('：', style: TextStyle(fontSize: 14)),
        Expanded(
          child: _isEditing 
            ? TextField(
                controller: label == '名前' ? _nameController : null,
                style: TextStyle(fontSize: 14),
                onChanged: onValueChanged,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              )
            : Text(
                value,
                style: TextStyle(fontSize: 14),
              ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: List.generate(8, (index) {
                bool isFilled = index < (progress * 8).floor();
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isFilled ? Colors.black : Colors.white,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSelectionRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '学年',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Text('：', style: TextStyle(fontSize: 14)),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedGrade,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: _gradeOptions.map((grade) {
              return DropdownMenuItem(
                value: grade,
                child: Text(grade),
              );
            }).toList(),
            onChanged: _isEditing ? (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedGrade = newValue;
                  _updateJobHuntingPeriod();
                });
                // 学年が変更されたら自動保存
                _saveData();
              }
            } : null,
          ),
        ),
      ],
    );
  }
}