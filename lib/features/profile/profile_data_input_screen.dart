import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

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
  
  // 学年選択肢リストを追加（クラスの先頭に）
  final List<Map<String, dynamic>> gradeOptions = [
    {'label': '1年', 'value': 1},
    {'label': '2年', 'value': 2},
    {'label': '3年', 'value': 3},
    {'label': '4年', 'value': 4},
    {'label': 'M1', 'value': 5},
    {'label': 'M2', 'value': 6},
  ];

  @override
  void initState() {
    super.initState();
    _checkDataExists();
  }

  Future<void> _checkDataExists() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('name') != null) {
      if (!mounted) return;
      context.go('/profile');
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

    String limitedName =
        _nameController.text.length > 24
            ? _nameController.text.substring(0, 24)
            : _nameController.text;
    String limitedCompany =
        _companyController.text.length > 36
            ? _companyController.text.substring(0, 36)
            : _companyController.text;

    DateTime currentDate = DateTime.now();
    DateTime endDate = _getEndDate(_selectedGrade);
    _weeksLeft = _calculateWeeksLeft(currentDate, endDate);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', limitedName);
    await prefs.setInt('grade', _selectedGrade);
    await prefs.setString('company', limitedCompany);
    await prefs.setString('date', currentDate.toIso8601String());

    if (!mounted) return;

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
      builder:
          (context) => AlertDialog(
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
    int mappedGrade = grade;
    if (grade == 5) mappedGrade = 3; // M1→3年
    if (grade == 6) mappedGrade = 4; // M2→4年
    int year = DateTime.now().year + (5 - mappedGrade);
    return DateTime(year, 4, 1);
  }

  int _calculateWeeksLeft(DateTime startDate, DateTime endDate) {
    int daysDifference = endDate.difference(startDate).inDays;
    return (daysDifference / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("プロフィール入力欄")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // タイトル行
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: const Text(
                  "プロフィール",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
              ),
              Divider(color: Colors.black, thickness: 1),
              // 氏名欄
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: const Text(
                        "氏名",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: "氏名を入力（24文字以内）",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLength: 24,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black, thickness: 1),
              // 学年欄
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: const Text(
                        "学年",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: Container(                        
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<int>(
                          value: _selectedGrade,
                          items: gradeOptions
                              .map((option) => DropdownMenuItem(
                                    value: option['value'] as int,
                                    child: Text(option['label'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGrade = value!;
                            });
                          },
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black, thickness: 1),
              // 志望企業欄
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "志望企業",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _companyController,
                          decoration: const InputDecoration(
                            hintText: "志望企業を入力（36文字以内）",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLength: 36,
                          minLines: 3,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black, thickness: 1),
              // 保存ボタン（上下スペースを均等に）
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: const Text("保存"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
