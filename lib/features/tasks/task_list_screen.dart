import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/shared/models/task.dart';

class GoalListScreen extends StatelessWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ★★★ 変更点 ★★★
    // Scaffold全体をConsumerウィジェットで囲む
    return Consumer<GoalModel>(
      builder: (context, goalModel, child) {
        // これ以降、"goalModel"という変数でGoalModelにアクセスできる
        return Scaffold(
          appBar: AppBar(
            title: const Text('目標リスト'),
          ),
          body: ListView.builder(
            itemCount: goalModel.mediumGoals.length,
            itemBuilder: (context, index) {
              final mediumGoal = goalModel.mediumGoals[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(mediumGoal.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: mediumGoal.deadline != null ? Text('期限: ${DateFormat('yyyy/MM/dd').format(mediumGoal.deadline!)}') : null,
                      onTap: () => goalModel.showAddSmallGoalDialog(context, mediumGoal),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                goalModel.showEditMediumGoalDialog(context, mediumGoal);
                              } else if (value == 'delete') {
                                goalModel.showDeleteConfirmDialog(context, goal: mediumGoal);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(value: 'edit', child: Text('編集')),
                              const PopupMenuItem<String>(value: 'delete', child: Text('削除')),
                            ],
                          ),
                          IconButton(
                            icon: Icon(mediumGoal.isExpanded ? Icons.expand_less : Icons.expand_more),
                            onPressed: () => goalModel.toggleMediumGoalExpansion(mediumGoal),
                          ),
                        ],
                      ),
                    ),
                    if (mediumGoal.isExpanded)
                      Column(
                        children: mediumGoal.smallGoals.map((smallGoal) {
                          return ListTile(
                            leading: Checkbox(value: smallGoal.isCompleted, onChanged: (bool? value) => goalModel.toggleSmallGoalCompletion(smallGoal)),
                            title: Text(smallGoal.title, style: TextStyle(decoration: smallGoal.isCompleted ? TextDecoration.lineThrough : TextDecoration.none)),
                            subtitle: smallGoal.deadline != null ? Text('期限: ${DateFormat('yyyy/MM/dd').format(smallGoal.deadline!)}') : null,
                            dense: true,
                            onTap: () => goalModel.toggleSmallGoalCompletion(smallGoal),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  goalModel.showEditSmallGoalDialog(context, mediumGoal, smallGoal);
                                } else if (value == 'delete') {
                                  goalModel.showDeleteConfirmDialogForSmallGoal(context, parentGoal: mediumGoal, smallGoal: smallGoal);
                                }
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => goalModel.showAddMediumGoalDialog(context),
            tooltip: '中目標を追加',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}