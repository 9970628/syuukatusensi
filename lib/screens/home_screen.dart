// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/models/task.dart';
import 'package:sennsi_app/screens/calendar_screen.dart';
import 'package:sennsi_app/screens/game_screen.dart'; // game_screenをインポート
import 'package:sennsi_app/screens/status_screen.dart';
import 'package:sennsi_app/screens/task_list_screen.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Widget> _buildUpcomingTasks(BuildContext context, List<MediumGoal> mediumGoals) {
    final List<Widget> upcomingTaskWidgets = [];
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final oneWeekFromNow = startOfToday.add(const Duration(days: 8));
    final List<Map<String, dynamic>> tasksToSort = [];

    for (var mGoal in mediumGoals) {
      if (mGoal.deadline != null && !mGoal.deadline!.isBefore(startOfToday) && mGoal.deadline!.isBefore(oneWeekFromNow)) {
        tasksToSort.add({'goal': mGoal, 'type': 'medium'});
      }
      for (var sGoal in mGoal.smallGoals) {
        if (!sGoal.isCompleted && sGoal.deadline != null && !sGoal.deadline!.isBefore(startOfToday) && sGoal.deadline!.isBefore(oneWeekFromNow)) {
          tasksToSort.add({'goal': sGoal, 'type': 'small', 'parentTitle': mGoal.title});
        }
      }
    }

    tasksToSort.sort((a, b) => (a['goal'].deadline as DateTime).compareTo(b['goal'].deadline as DateTime));

    for (var taskData in tasksToSort) {
      if (taskData['type'] == 'medium') {
        MediumGoal goal = taskData['goal'];
        upcomingTaskWidgets.add(ListTile(leading: const Icon(Icons.star, color: Colors.amber), title: Text(goal.title), subtitle: Text('期限: ${DateFormat('M/d(E)', 'ja').format(goal.deadline!)}')));
      } else if (taskData['type'] == 'small') {
        SmallGoal goal = taskData['goal'];
        String parentTitle = taskData['parentTitle'];
        upcomingTaskWidgets.add(ListTile(leading: const Icon(Icons.check_box_outline_blank), title: Text(goal.title), subtitle: Text('$parentTitle / 期限: ${DateFormat('M/d(E)', 'ja').format(goal.deadline!)}')));
      }
    }
    if (upcomingTaskWidgets.isEmpty) {
      return [const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text('1週間以内に期限のタスクはありません。')))];
    }
    return upcomingTaskWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('M月d日 (E)', 'ja').format(DateTime.now());

    return Scaffold(

      appBar: AppBar(title: const Text('ホーム')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(today, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const StatusScreen()));}, child: const Text('ステータス')),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const GameScreen()));}, child: const Text('ゲーム')),
                          ],
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(width: 200, height: 200, color: Colors.grey[300]),
                              Positioned(top: 40, left: 40, child: Container(width: 150, height: 150, color: Colors.grey[400])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}