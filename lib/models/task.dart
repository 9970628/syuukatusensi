// lib/models/task.dart

import 'package:flutter/material.dart';
// ★★★ 変更点：新しいダイアログファイルをインポート ★★★
import 'package:sennsi_app/widgets/add_edit_medium_goal_dialog.dart';
import 'package:sennsi_app/widgets/add_edit_small_goal_dialog.dart';

// --- データモデルの定義 ---
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

// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
// ★ 新しい司令塔：データとロジックを管理するGoalModel ★
// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
class GoalModel extends ChangeNotifier {
  // --- データ ---
  final List<MediumGoal> _mediumGoals = [];

  // 外部からデータを読み取るための getter
  List<MediumGoal> get mediumGoals => _mediumGoals;

  // --- メソッド ---

  // データが変更されたことをUIに通知する
  void _notify() => notifyListeners();

  // 中目標の操作
  void addMediumGoal(String title, DateTime? deadline) { _mediumGoals.add(MediumGoal(title: title, deadline: deadline, smallGoals: [])); _notify(); }
  void editMediumGoal(MediumGoal goalToEdit, String newTitle, DateTime? newDeadline) { goalToEdit.title = newTitle; goalToEdit.deadline = newDeadline; _notify(); }
  void deleteMediumGoal(MediumGoal goalToDelete) { _mediumGoals.remove(goalToDelete); _notify(); }
  
  // 小目標の操作
  void addSmallGoal(MediumGoal parentGoal, String title, DateTime? deadline) { parentGoal.smallGoals.add(SmallGoal(title: title, deadline: deadline)); _notify(); }
  void toggleSmallGoalCompletion(SmallGoal smallGoal) { smallGoal.isCompleted = !smallGoal.isCompleted; _notify(); }
  void editSmallGoal(SmallGoal goalToEdit, String newTitle, DateTime? newDeadline) { goalToEdit.title = newTitle; goalToEdit.deadline = newDeadline; _notify(); }
  void deleteSmallGoal(MediumGoal parentGoal, SmallGoal smallGoal) { parentGoal.smallGoals.remove(smallGoal); _notify(); }

  // 開閉状態の操作 (UIの状態なので、ここではsetStateの代わりにnotifyListenersを呼ぶ)
  void toggleMediumGoalExpansion(MediumGoal goal) { goal.isExpanded = !goal.isExpanded; _notify(); }
  
  // ダイアログ表示メソッド (BuildContextが必要なので引数で受け取る)
  void showAddMediumGoalDialog(BuildContext context) { showDialog(context: context, builder: (context) => AddOrEditMediumGoalDialog(onSave: addMediumGoal)); }
  void showEditMediumGoalDialog(BuildContext context, MediumGoal goal) { showDialog(context: context, builder: (context) => AddOrEditMediumGoalDialog(onSave: (title, deadline) => editMediumGoal(goal, title, deadline), isEditMode: true, initialGoal: goal)); }
  void showAddSmallGoalDialog(BuildContext context, MediumGoal parentGoal) { showDialog(context: context, builder: (context) => AddOrEditSmallGoalDialog(onSave: (title, deadline) => addSmallGoal(parentGoal, title, deadline))); }
  void showEditSmallGoalDialog(BuildContext context, MediumGoal parentGoal, SmallGoal smallGoal) { showDialog(context: context, builder: (context) => AddOrEditSmallGoalDialog(onSave: (title, deadline) => editSmallGoal(smallGoal, title, deadline), isEditMode: true, initialGoal: smallGoal)); }
  
  void showDeleteConfirmDialog(BuildContext context, {required MediumGoal goal}) {
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      title: const Text('目標の削除'), content: Text('「${goal.title}」を本当に削除しますか？\n（中の小目標もすべて削除されます）'),
      actions: <Widget>[ TextButton(child: const Text('キャンセル'), onPressed: () => Navigator.of(context).pop()), TextButton(child: const Text('削除', style: TextStyle(color: Colors.red)), onPressed: () { deleteMediumGoal(goal); Navigator.of(context).pop(); })],
    ));
  }
  void showDeleteConfirmDialogForSmallGoal(BuildContext context, {required MediumGoal parentGoal, required SmallGoal smallGoal}) {
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      title: const Text('小目標の削除'), content: Text('「${smallGoal.title}」を本当に削除しますか？'),
      actions: <Widget>[ TextButton(child: const Text('キャンセル'), onPressed: () => Navigator.of(context).pop()), TextButton(child: const Text('削除', style: TextStyle(color: Colors.red)), onPressed: () { deleteSmallGoal(parentGoal, smallGoal); Navigator.of(context).pop(); })],
    ));
  }
}