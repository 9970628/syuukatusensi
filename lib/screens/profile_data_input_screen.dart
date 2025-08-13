import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // Timer 用

class ProfileDataInputScreen extends StatefulWidget {
  const ProfileDataInputScreen({super.key});

  @override
  State<ProfileDataInputScreen> createState() => _ProfileDataInputScreenState();
}

class _ProfileDataInputScreenState extends State<ProfileDataInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  int _selectedGrade = 1;
  int _weeksLeft = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDataExists();
  }

  Future<void> _checkDataExists() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('name') != null) {
      if (!mounted) return;
      context.go('/profile'); // データが既にあればプロフィール画面へ
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveData() async {
    if (_nameController.text.isEmpty || _companyController.text.isEmpty) {
      _showErrorDialog("すべての項目を入力してください！");
      return;
    }

    // 名前を24文字以内に制限
    String limitedName = _nameController.text.length > 24
        ? _nameController.text.substring(0, 24)
        : _nameController.text;
    // 志望企業を36文字以内に制限
    String limitedCompany = _companyController.text.length > 36
        ? _companyController.text.substring(0, 36)
        : _companyController.text;

    // 現在の日付を自動取得
    DateTime currentDate = DateTime.now();

    // 残り週を計算
    DateTime endDate = _getEndDate(_selectedGrade);
    _weeksLeft = _calculateWeeksLeft(currentDate, endDate);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', limitedName);
    await prefs.setInt('grade', _selectedGrade);
    await prefs.setString('company', limitedCompany);
    await prefs.setString('date', currentDate.toIso8601String());

    if (!mounted) return;

    // データを次の画面に渡す
    context.go(
      '/profile',
      extra: {
        'name': limitedName,
        'grade': _selectedGrade,
        'company': limitedCompany,
        'weeksLeft': _weeksLeft,
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("入力エラー"),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  DateTime _getEndDate(int grade) {
    int year = DateTime.now().year + (5 - grade);
    return DateTime(year, 4, 1);
  }

  int _calculateWeeksLeft(DateTime startDate, DateTime endDate) {
    int daysDifference = endDate.difference(startDate).inDays;
    return (daysDifference / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("初期データ入力")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "名前（24文字以内）"),
            ),
            DropdownButton<int>(
              value: _selectedGrade,
              items: List.generate(4, (index) => index + 1)
                  .map((grade) => DropdownMenuItem(
                        value: grade,
                        child: Text("$grade 年"),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGrade = value!;
                });
              },
            ),
            TextField(
              controller: _companyController,
              decoration: const InputDecoration(labelText: "志望企業（36文字以内）"),
            ),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text("保存"),
            ),
          ],
        ),
      ),
    );
  }
}
