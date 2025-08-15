import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/shared/models/task.dart';

class GoalListScreen extends StatelessWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalModel>(
      builder: (context, goalModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E), // ダークブルー背景
          appBar: AppBar(
            title: const Text(
              '就活クエストボード',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: const Color(0xFF16213E),
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF16213E), Color(0xFF0F3460)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child:
                goalModel.mediumGoals.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: goalModel.mediumGoals.length,
                      itemBuilder: (context, index) {
                        final mediumGoal = goalModel.mediumGoals[index];
                        return _buildQuestCard(context, goalModel, mediumGoal);
                      },
                    ),
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFE94560), Color(0xFFFF6B6B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE94560).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => goalModel.showAddMediumGoalDialog(context),
              tooltip: '新しいクエストを追加',
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.add_task, color: Colors.white, size: 28),
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF533483), width: 2),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Color(0xFF533483),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '🎮 クエストボードは空です',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '新しい就活クエストを追加して\n冒険を始めましょう！',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F3460).withOpacity(0.8),
            const Color(0xFF533483).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color:
              progress == 1.0
                  ? const Color(0xFF4ECDC4)
                  : const Color(0xFF533483),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (progress == 1.0
                    ? const Color(0xFF4ECDC4)
                    : const Color(0xFF533483))
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // クエストヘッダー
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              gradient: LinearGradient(
                colors:
                    progress == 1.0
                        ? [const Color(0xFF4ECDC4), const Color(0xFF44A08D)]
                        : [const Color(0xFF16213E), const Color(0xFF0F3460)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                                ? Colors.white.withOpacity(0.2)
                                : const Color(0xFFE94560).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              progress == 1.0
                                  ? Colors.white.withOpacity(0.3)
                                  : const Color(0xFFE94560).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        progress == 1.0 ? '🏆 COMPLETE' : '⚔️ QUEST',
                        style: TextStyle(
                          color:
                              progress == 1.0
                                  ? Colors.white
                                  : const Color(0xFFE94560),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (mediumGoal.deadline != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: Color(0xFFFFB74D),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '期限: ${DateFormat('yyyy/MM/dd').format(mediumGoal.deadline!)}',
                        style: const TextStyle(
                          color: Color(0xFFFFB74D),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // プログレスバー
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress: $completedTasks/$totalTasks',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(
                              colors:
                                  progress == 1.0
                                      ? [
                                        const Color(0xFF4ECDC4),
                                        const Color(0xFF44A08D),
                                      ]
                                      : [
                                        const Color(0xFFE94560),
                                        const Color(0xFFFF6B6B),
                                      ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          () => goalModel.showAddSmallGoalDialog(
                            context,
                            mediumGoal,
                          ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('タスク追加'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE94560),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        mediumGoal.isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.white70,
                      ),
                      onPressed:
                          () => goalModel.toggleMediumGoalExpansion(mediumGoal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // タスクリスト
          if (mediumGoal.isExpanded && mediumGoal.smallGoals.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
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
      icon: const Icon(Icons.more_vert, color: Colors.white70),
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
                  Icon(Icons.edit, color: Color(0xFF533483)),
                  SizedBox(width: 8),
                  Text('編集'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('削除'),
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            smallGoal.isCompleted
                ? const Color(0xFF4ECDC4).withOpacity(0.1)
                : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              smallGoal.isCompleted
                  ? const Color(0xFF4ECDC4).withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => goalModel.toggleSmallGoalCompletion(smallGoal),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    smallGoal.isCompleted
                        ? const Color(0xFF4ECDC4)
                        : Colors.transparent,
                border: Border.all(
                  color:
                      smallGoal.isCompleted
                          ? const Color(0xFF4ECDC4)
                          : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child:
                  smallGoal.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
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
                        smallGoal.isCompleted ? Colors.white70 : Colors.white,
                    fontSize: 14,
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
                        Icons.schedule,
                        color: Color(0xFFFFB74D),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MM/dd').format(smallGoal.deadline!),
                        style: const TextStyle(
                          color: Color(0xFFFFB74D),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: Colors.white54, size: 20),
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
                        Icon(Icons.edit, color: Color(0xFF533483), size: 16),
                        SizedBox(width: 8),
                        Text('編集'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text('削除'),
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
