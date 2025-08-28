import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/shared/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalListScreen extends StatefulWidget {
  const GoalListScreen({super.key});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  @override
  void initState() {
    super.initState();
    // GoalModelのloadGoalsを呼ぶ
    Future.microtask(() {
      // Provider経由でGoalModelを取得
      final goalModel = Provider.of<GoalModel>(context, listen: false);
      goalModel.loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalModel>(
      builder: (context, goalModel, child) {
        // 全体の統計を計算
        final totalMediumGoals = goalModel.mediumGoals.length;
        final completedMediumGoals = goalModel.mediumGoals
            .where((goal) => goal.smallGoals.isNotEmpty && 
                           goal.smallGoals.every((small) => small.isCompleted))
            .length;
        final totalSmallGoals = goalModel.mediumGoals
            .expand((goal) => goal.smallGoals)
            .length;
        final completedSmallGoals = goalModel.mediumGoals
            .expand((goal) => goal.smallGoals)
            .where((small) => small.isCompleted)
            .length;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              '就活タスク管理表',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            shadowColor: Colors.black12,
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              image: DecorationImage(
                image: NetworkImage(
                  'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHZpZXdCb3g9IjAgMCAyMCAyMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGRlZnM+CjxwYXR0ZXJuIGlkPSJncmlkIiB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiPgo8cGF0aCBkPSJNIDIwIDAgTCAwIDAgMCAyMCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjRTBFNkVEIiBzdHJva2Utd2lkdGg9IjEiLz4KPC9wYXR0ZXJuPgo8L2RlZnM+CjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZ3JpZCkiIC8+Cjwvc3ZnPg==',
                ),
                repeat: ImageRepeat.repeat,
                opacity: 0.3,
              ),
            ),
            child: Column(
              children: [
                // 統計情報を表示するヘッダー部分
                if (goalModel.mediumGoals.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF34495E), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '進捗状況',
                          style: TextStyle(
                            color: Color(0xFF2C3E50),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3498DB).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: const Color(0xFF3498DB).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '中間タスク',
                                      style: TextStyle(
                                        color: Color(0xFF3498DB),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$completedMediumGoals / $totalMediumGoals',
                                      style: const TextStyle(
                                        color: Color(0xFF2C3E50),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF27AE60).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: const Color(0xFF27AE60).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '小タスク',
                                      style: TextStyle(
                                        color: Color(0xFF27AE60),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$completedSmallGoals / $totalSmallGoals',
                                      style: const TextStyle(
                                        color: Color(0xFF2C3E50),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                // メインコンテンツ
                Expanded(
                  child: goalModel.mediumGoals.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: goalModel.mediumGoals.length,
                          itemBuilder: (context, index) {
                            final mediumGoal = goalModel.mediumGoals[index];
                            return _buildQuestCard(context, goalModel, mediumGoal);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF3498DB),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3498DB).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => goalModel.showAddMediumGoalDialog(context),
              tooltip: '新しいタスクを追加',
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF34495E), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  size: 48,
                  color: Color(0xFF34495E),
                ),
                const SizedBox(height: 16),
                const Text(
                  'タスクが登録されていません',
                  style: TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '就活に関するタスクを追加して\n効率的に進めましょう',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestCard(
    BuildContext context,
    GoalModel goalModel,
    MediumGoal mediumGoal,
  ) {
    final completedTasks =
        mediumGoal.smallGoals.where((task) => task.isCompleted).length;
    final totalTasks = mediumGoal.smallGoals.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color:
              progress == 1.0
                  ? const Color(0xFF27AE60)
                  : const Color(0xFF34495E),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  progress == 1.0
                      ? const Color(0xFF27AE60).withOpacity(0.1)
                      : const Color(0xFFF8F9FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0xFFE0E6ED), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            progress == 1.0
                                ? const Color(0xFF27AE60)
                                : const Color(0xFF3498DB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        progress == 1.0 ? '完了' : '進行中',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildQuestMenu(context, goalModel, mediumGoal),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  mediumGoal.title,
                  style: const TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (mediumGoal.deadline != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        color: Color(0xFFE67E22),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '期限: ${DateFormat('yyyy/MM/dd').format(mediumGoal.deadline!)}',
                        style: const TextStyle(
                          color: Color(0xFFE67E22),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '進捗: $completedTasks/$totalTasks',
                          style: const TextStyle(
                            color: Color(0xFF7F8C8D),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: const Color(0xFFE0E6ED),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color:
                                progress == 1.0
                                    ? const Color(0xFF27AE60)
                                    : const Color(0xFF3498DB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed:
                          () => goalModel.showAddSmallGoalDialog(
                            context,
                            mediumGoal,
                          ),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('タスク追加'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3498DB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        mediumGoal.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF7F8C8D),
                        size: 20,
                      ),
                      onPressed:
                          () => goalModel.toggleMediumGoalExpansion(mediumGoal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (mediumGoal.isExpanded && mediumGoal.smallGoals.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFBFC),
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E6ED), width: 1),
                ),
              ),
              child: Column(
                children:
                    mediumGoal.smallGoals.map((smallGoal) {
                      return _buildTaskItem(
                        context,
                        goalModel,
                        mediumGoal,
                        smallGoal,
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestMenu(
    BuildContext context,
    GoalModel goalModel,
    MediumGoal mediumGoal,
  ) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Color(0xFF7F8C8D), size: 18),
      onSelected: (value) {
        if (value == 'edit') {
          goalModel.showEditMediumGoalDialog(context, mediumGoal);
        } else if (value == 'delete') {
          goalModel.showDeleteConfirmDialog(context, goal: mediumGoal);
        }
      },
      itemBuilder:
          (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: Color(0xFF3498DB), size: 16),
                  SizedBox(width: 8),
                  Text('編集', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: Color(0xFFE74C3C),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text('削除', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    GoalModel goalModel,
    MediumGoal mediumGoal,
    SmallGoal smallGoal,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            smallGoal.isCompleted
                ? const Color(0xFF27AE60).withOpacity(0.05)
                : Colors.white,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE0E6ED), width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // トグル前の状態を保存
              final wasCompleted = smallGoal.isCompleted;

              // 完了状態をトグル
              goalModel.toggleSmallGoalCompletion(smallGoal);

              // タスク数を更新
              final prefs = await SharedPreferences.getInstance();
              int totalTasks = prefs.getInt('totalTasks') ?? 0;

              if (!wasCompleted) {
                // チェックを入れる → +1
                totalTasks += 1;
              } else {
                // チェックを外す → -1
                totalTasks = totalTasks > 0 ? totalTasks - 1 : 0;
              }
              await prefs.setInt('totalTasks', totalTasks);
            },
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color:
                    smallGoal.isCompleted
                        ? const Color(0xFF27AE60)
                        : Colors.white,
                border: Border.all(
                  color:
                      smallGoal.isCompleted
                          ? const Color(0xFF27AE60)
                          : const Color(0xFFBDC3C7),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child:
                  smallGoal.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  smallGoal.title,
                  style: TextStyle(
                    color:
                        smallGoal.isCompleted
                            ? const Color(0xFF7F8C8D)
                            : const Color(0xFF2C3E50),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration:
                        smallGoal.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                  ),
                ),
                if (smallGoal.deadline != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        color: Color(0xFFE67E22),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MM/dd').format(smallGoal.deadline!),
                        style: const TextStyle(
                          color: Color(0xFFE67E22),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: Color(0xFF7F8C8D),
              size: 16,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                goalModel.showEditSmallGoalDialog(
                  context,
                  mediumGoal,
                  smallGoal,
                );
              } else if (value == 'delete') {
                goalModel.showDeleteConfirmDialogForSmallGoal(
                  context,
                  parentGoal: mediumGoal,
                  smallGoal: smallGoal,
                );
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF3498DB),
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text('編集', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Color(0xFFE74C3C),
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text('削除', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}
