import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// =================================================================
// ★ 1. データ構造の定義 (Data Models)
// =================================================================
class SmallGoal {
  String title;
  DateTime? deadline;
  bool isCompleted;

  SmallGoal({ required this.title, this.deadline, this.isCompleted = false });
}

class MediumGoal {
  String title;
  DateTime? deadline;
  List<SmallGoal> smallGoals;
  bool isExpanded;

  MediumGoal({ required this.title, this.deadline, required this.smallGoals, this.isExpanded = false });
}

// =================================================================
// ★ 2. メイン画面のウィジェット (Main Screen Widget)
// =================================================================
class GoalListScreen extends StatefulWidget {
  const GoalListScreen({super.key});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  // --- 状態（データ） ---
  final List<MediumGoal> _mediumGoals = [];

  // =================================================================
  // ★ 3. メソッド定義 (Methods)
  // =================================================================

  // --- メソッド：中目標の操作 ---

  void _addMediumGoal(String title, DateTime? deadline) {
    setState(() { _mediumGoals.add(MediumGoal(title: title, deadline: deadline, smallGoals: [])); });
  }

  void _showAddMediumGoalDialog() {
    showDialog(context: context, builder: (context) => AddOrEditMediumGoalDialog(onSave: _addMediumGoal));
  }

  void _editMediumGoal(MediumGoal goalToEdit, String newTitle, DateTime? newDeadline) {
    setState(() {
      goalToEdit.title = newTitle;
      goalToEdit.deadline = newDeadline;
    });
  }

  void _showEditMediumGoalDialog(MediumGoal goal) {
    showDialog(context: context, builder: (context) => AddOrEditMediumGoalDialog(
      onSave: (title, deadline) => _editMediumGoal(goal, title, deadline),
      isEditMode: true,
      initialGoal: goal,
    ));
  }
  
  void _deleteMediumGoal(MediumGoal goalToDelete) {
    setState(() {
      _mediumGoals.remove(goalToDelete);
    });
  }

  void _showDeleteConfirmDialog(BuildContext context, {required MediumGoal goal}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('目標の削除'),
          content: Text('「${goal.title}」を本当に削除しますか？\n（中の小目標もすべて削除されます）'),
          actions: <Widget>[
            TextButton(child: const Text('キャンセル'), onPressed: () => Navigator.of(context).pop()),
            TextButton(child: const Text('削除', style: TextStyle(color: Colors.red)), onPressed: () { _deleteMediumGoal(goal); Navigator.of(context).pop(); }),
          ],
        );
      },
    );
  }

  // --- メソッド：小目標の操作 ---

  void _addSmallGoal(MediumGoal parentGoal, String title, DateTime? deadline) {
    setState(() { parentGoal.smallGoals.add(SmallGoal(title: title, deadline: deadline)); });
  }
  
  void _toggleSmallGoalCompletion(SmallGoal smallGoal) {
    setState(() { smallGoal.isCompleted = !smallGoal.isCompleted; });
  }

  void _showAddSmallGoalDialog(MediumGoal parentGoal) {
    showDialog(context: context, builder: (context) => AddOrEditSmallGoalDialog(onSave: (title, deadline) => _addSmallGoal(parentGoal, title, deadline)));
  }

  // ★★★ 小目標の編集・削除機能 ★★★
  void _editSmallGoal(SmallGoal goalToEdit, String newTitle, DateTime? newDeadline) {
    setState(() {
      goalToEdit.title = newTitle;
      goalToEdit.deadline = newDeadline;
    });
  }

  // ★★★ 小目標の編集・削除機能 ★★★
  void _showEditSmallGoalDialog(MediumGoal parentGoal, SmallGoal smallGoal) {
    showDialog(context: context, builder: (context) => AddOrEditSmallGoalDialog(
      onSave: (title, deadline) => _editSmallGoal(smallGoal, title, deadline),
      isEditMode: true,
      initialGoal: smallGoal,
    ));
  }

  // ★★★ 小目標の編集・削除機能 ★★★
  void _deleteSmallGoal(MediumGoal parentGoal, SmallGoal smallGoal) {
    setState(() {
      parentGoal.smallGoals.remove(smallGoal);
    });
  }

  // ★★★ 小目標の編集・削除機能 ★★★
  void _showDeleteConfirmDialogForSmallGoal(BuildContext context, {required MediumGoal parentGoal, required SmallGoal smallGoal}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('小目標の削除'),
          content: Text('「${smallGoal.title}」を本当に削除しますか？'),
          actions: <Widget>[
            TextButton(child: const Text('キャンセル'), onPressed: () => Navigator.of(context).pop()),
            TextButton(child: const Text('削除', style: TextStyle(color: Colors.red)), onPressed: () { _deleteSmallGoal(parentGoal, smallGoal); Navigator.of(context).pop(); }),
          ],
        );
      },
    );
  }

  // =================================================================
  // ★ 4. UIの構築 (Build Method)
  // =================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('目標リスト')),
      body: ListView.builder(
        itemCount: _mediumGoals.length,
        itemBuilder: (context, index) {
          final mediumGoal = _mediumGoals[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  title: Text(mediumGoal.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: mediumGoal.deadline != null ? Text('期限: ${DateFormat('yyyy/MM/dd').format(mediumGoal.deadline!)}') : null,
                  onTap: () => _showAddSmallGoalDialog(mediumGoal),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') _showEditMediumGoalDialog(mediumGoal);
                          else if (value == 'delete') _showDeleteConfirmDialog(context, goal: mediumGoal);
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(value: 'edit', child: Text('編集')),
                          const PopupMenuItem<String>(value: 'delete', child: Text('削除')),
                        ],
                      ),
                      IconButton(icon: Icon(mediumGoal.isExpanded ? Icons.expand_less : Icons.expand_more), onPressed: () => setState(() => mediumGoal.isExpanded = !mediumGoal.isExpanded)),
                    ],
                  ),
                ),
                if (mediumGoal.isExpanded)
                  Column(
                    children: mediumGoal.smallGoals.map((smallGoal) {
                      return ListTile(
                        leading: Checkbox(value: smallGoal.isCompleted, onChanged: (bool? value) => _toggleSmallGoalCompletion(smallGoal)),
                        title: Text(smallGoal.title, style: TextStyle(decoration: smallGoal.isCompleted ? TextDecoration.lineThrough : TextDecoration.none)),
                        subtitle: smallGoal.deadline != null ? Text('期限: ${DateFormat('yyyy/MM/dd').format(smallGoal.deadline!)}') : null,
                        dense: true,
                        onTap: () => _toggleSmallGoalCompletion(smallGoal),
                        // ★★★ 小目標の編集・削除機能 ★★★
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') _showEditSmallGoalDialog(mediumGoal, smallGoal);
                            else if (value == 'delete') _showDeleteConfirmDialogForSmallGoal(context, parentGoal: mediumGoal, smallGoal: smallGoal);
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(value: 'edit', child: Text('編集')),
                            const PopupMenuItem<String>(value: 'delete', child: Text('削除')),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddMediumGoalDialog, child: const Icon(Icons.add)),
    );
  }
}

// =================================================================
// ★ 5. ダイアログのウィジェット (Dialog Widgets)
// =================================================================

// --- ダイアログ：中目標の追加・編集 ---
class AddOrEditMediumGoalDialog extends StatefulWidget {
  final Function(String title, DateTime? deadline) onSave;
  final bool isEditMode;
  final MediumGoal? initialGoal;

  const AddOrEditMediumGoalDialog({ super.key, required this.onSave, this.isEditMode = false, this.initialGoal });

  @override
  State<AddOrEditMediumGoalDialog> createState() => _AddOrEditMediumGoalDialogState();
}
class _AddOrEditMediumGoalDialogState extends State<AddOrEditMediumGoalDialog> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.initialGoal != null) {
      _titleController.text = widget.initialGoal!.title;
      _selectedDate = widget.initialGoal!.deadline;
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) setState(() { _selectedDate = picked; });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditMode ? '中目標の編集' : '中目標の追加'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _titleController, decoration: const InputDecoration(hintText: '目標のタイトル'), autofocus: true),
        const SizedBox(height: 16),
        Row(children: [ Expanded(child: Text(_selectedDate == null ? '期限を選択' : '期限: ${DateFormat('yyyy/MM/dd').format(_selectedDate!)}')), IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate) ])
      ]),
      actions: <Widget>[
        TextButton(child: const Text('キャンセル'), onPressed: () => Navigator.of(context).pop()),
        TextButton(child: Text(widget.isEditMode ? '保存' : '追加'), onPressed: () { if (_titleController.text.isNotEmpty) { widget.onSave(_titleController.text, _selectedDate); Navigator.of(context).pop(); } }),
      ],
    );
  }
}

// --- ダイアログ：小目標の追加・編集 ---
class AddOrEditSmallGoalDialog extends StatefulWidget {
  final Function(String title, DateTime? deadline) onSave;
  final bool isEditMode; // ★★★ 小目標の編集・削除機能 ★★★
  final SmallGoal? initialGoal; // ★★★ 小目標の編集・削除機能 ★★★

  const AddOrEditSmallGoalDialog({ super.key, required this.onSave, this.isEditMode = false, this.initialGoal });

  @override
  State<AddOrEditSmallGoalDialog> createState() => _AddOrEditSmallGoalDialogState();
}
class _AddOrEditSmallGoalDialogState extends State<AddOrEditSmallGoalDialog> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  // ★★★ 小目標の編集・削除機能 ★★★
  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.initialGoal != null) {
      _titleController.text = widget.initialGoal!.title;
      _selectedDate = widget.initialGoal!.deadline;
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) setState(() { _selectedDate = picked; });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditMode ? '小目標の編集' : '小目標の追加'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'やるべきことを入力'), autofocus: true),
        const SizedBox(height: 16),
        Row(children: [ Expanded(child: Text(_selectedDate == null ? '期限を選択' : '期限: ${DateFormat('yyyy/MM/dd').format(_selectedDate!)}')), IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate) ])
      ]),
      actions: <Widget>[
        TextButton(child: const Text('キャンセル'), onPressed: () => Navigator.of(context).pop()),
        TextButton(child: Text(widget.isEditMode ? '保存' : '追加'), onPressed: () { if (_titleController.text.isNotEmpty) { widget.onSave(_titleController.text, _selectedDate); Navigator.of(context).pop(); } }),
      ],
    );
  }
}