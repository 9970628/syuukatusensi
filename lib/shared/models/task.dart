// lib/models/task.dart

import 'package:flutter/material.dart';
// ★★★ 変更点：新しいダイアログファイルをインポート ★★★
import 'package:sennsi_app/shared/widgets/add_edit_medium_goal_dialog.dart';
import 'package:sennsi_app/shared/widgets/add_edit_small_goal_dialog.dart';

// --- データモデルの定義 ---
class SmallGoal {
  String title;
  DateTime? deadline;
  bool isCompleted;
  DateTime createdAt; // 作成日時を追加
  SmallGoal({
    required this.title,
    this.deadline,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class MediumGoal {
  String title;
  DateTime? deadline;
  List<SmallGoal> smallGoals;
  bool isExpanded;
  DateTime createdAt; // 作成日時を追加
  MediumGoal({
    required this.title,
    this.deadline,
    required this.smallGoals,
    this.isExpanded = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
// ★ 新しい司令塔：データとロジックを管理するGoalModel ★
// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
class GoalModel extends ChangeNotifier {
  // --- データ ---
  final List<MediumGoal> _mediumGoals = [];

  // 外部からデータを読み取るための getter
  List<MediumGoal> get mediumGoals => _mediumGoals;

  // カレンダー用のタスクデータを取得
  Map<String, List<String>> getCalendarTasks() {
    Map<String, List<String>> calendarData = {};

    // 中目標を追加（期限がある場合のみ）
    for (var mediumGoal in _mediumGoals) {
      if (mediumGoal.deadline != null) {
        String dateKey = _formatDate(mediumGoal.deadline!);
        if (!calendarData.containsKey(dateKey)) {
          calendarData[dateKey] = [];
        }
        calendarData[dateKey]!.add('📋 ${mediumGoal.title}');
      }

      // 小目標も追加（期限がある場合のみ）
      for (var smallGoal in mediumGoal.smallGoals) {
        if (smallGoal.deadline != null) {
          String smallGoalDateKey = _formatDate(smallGoal.deadline!);
          if (!calendarData.containsKey(smallGoalDateKey)) {
            calendarData[smallGoalDateKey] = [];
          }
          calendarData[smallGoalDateKey]!.add('✅ ${smallGoal.title}');
        }
      }
    }

    return calendarData;
  }

  // 日付をフォーマットするヘルパーメソッド
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // --- メソッド ---

  // データが変更されたことをUIに通知する
  void _notify() => notifyListeners();

  // 中目標の操作
  void addMediumGoal(String title, DateTime? deadline) {
    _mediumGoals.add(
      MediumGoal(title: title, deadline: deadline, smallGoals: []),
    );
    _notify();
  }

  void editMediumGoal(
    MediumGoal goalToEdit,
    String newTitle,
    DateTime? newDeadline,
  ) {
    goalToEdit.title = newTitle;
    goalToEdit.deadline = newDeadline;
    _notify();
  }

  void deleteMediumGoal(MediumGoal goalToDelete) {
    _mediumGoals.remove(goalToDelete);
    _notify();
  }

  // 小目標の操作
  void addSmallGoal(MediumGoal parentGoal, String title, DateTime? deadline) {
    parentGoal.smallGoals.add(SmallGoal(title: title, deadline: deadline));
    _notify();
  }

  void toggleSmallGoalCompletion(SmallGoal smallGoal) {
    smallGoal.isCompleted = !smallGoal.isCompleted;
    _notify();
  }

  void editSmallGoal(
    SmallGoal goalToEdit,
    String newTitle,
    DateTime? newDeadline,
  ) {
    goalToEdit.title = newTitle;
    goalToEdit.deadline = newDeadline;
    _notify();
  }

  void deleteSmallGoal(MediumGoal parentGoal, SmallGoal smallGoal) {
    parentGoal.smallGoals.remove(smallGoal);
    _notify();
  }

  // 開閉状態の操作 (UIの状態なので、ここではsetStateの代わりにnotifyListenersを呼ぶ)
  void toggleMediumGoalExpansion(MediumGoal goal) {
    goal.isExpanded = !goal.isExpanded;
    _notify();
  }

  // ダイアログ表示メソッド (BuildContextが必要なので引数で受け取る)
  void showAddMediumGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddOrEditMediumGoalDialog(onSave: addMediumGoal),
    );
  }

  void showEditMediumGoalDialog(BuildContext context, MediumGoal goal) {
    showDialog(
      context: context,
      builder:
          (context) => AddOrEditMediumGoalDialog(
            onSave: (title, deadline) => editMediumGoal(goal, title, deadline),
            isEditMode: true,
            initialGoal: goal,
          ),
    );
  }

  void showAddSmallGoalDialog(BuildContext context, MediumGoal parentGoal) {
    showDialog(
      context: context,
      builder:
          (context) => AddOrEditSmallGoalDialog(
            onSave:
                (title, deadline) => addSmallGoal(parentGoal, title, deadline),
          ),
    );
  }

  void showEditSmallGoalDialog(
    BuildContext context,
    MediumGoal parentGoal,
    SmallGoal smallGoal,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AddOrEditSmallGoalDialog(
            onSave:
                (title, deadline) => editSmallGoal(smallGoal, title, deadline),
            isEditMode: true,
            initialGoal: smallGoal,
          ),
    );
  }

  void showDeleteConfirmDialog(
    BuildContext context, {
    required MediumGoal goal,
  }) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('目標の削除'),
            content: Text('「${goal.title}」を本当に削除しますか？\n（中の小目標もすべて削除されます）'),
            actions: <Widget>[
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('削除', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  deleteMediumGoal(goal);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  void showDeleteConfirmDialogForSmallGoal(
    BuildContext context, {
    required MediumGoal parentGoal,
    required SmallGoal smallGoal,
  }) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('小目標の削除'),
            content: Text('「${smallGoal.title}」を本当に削除しますか？'),
            actions: <Widget>[
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('削除', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  deleteSmallGoal(parentGoal, smallGoal);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }
}
