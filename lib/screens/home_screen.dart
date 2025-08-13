import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/models/task.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sennsi_app/screens/calendar_screen.dart';
import 'package:sennsi_app/screens/game_screen.dart'; // game_screenをインポート
import 'package:sennsi_app/screens/status_screen.dart';
import 'package:sennsi_app/screens/task_list_screen.dart';
import 'package:go_router/go_router.dart';

// 画面遷移で直接ウィジェットを呼ばないので、以下のインポートは不要になることが多い
// import 'package:sennsi_app/screens/calendar_screen.dart';
// import 'package:sennsi_app/screens/game_screen.dart';
// import 'package:sennsi_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _jobHuntingPeriod = '情報取得中...';

  @override
  void initState() {
    super.initState();
    _loadJobHuntingPeriod();
  }

  Future<void> _loadJobHuntingPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedGrade = prefs.getString('user_grade') ?? '大学3年';
    
    DateTime now = DateTime.now();
    Map<String, int> gradeToGraduationYear = {
      '大学1年': now.year + 3,
      '大学2年': now.year + 2,
      '大学3年': now.year + 1,
      '大学4年': now.year,
      '大学院1年': now.year + 1,
      '大学院2年': now.year,
    };
    int graduationYear = gradeToGraduationYear[selectedGrade] ?? now.year;
    DateTime jobHuntingEnd = DateTime(graduationYear, 6, 30);
    DateTime jobHuntingStart = DateTime(graduationYear - 1, 3, 1);
    
    int totalWeeks = jobHuntingEnd.difference(now).inDays ~/ 7;
    int progressWeeks = now.difference(jobHuntingStart).inDays ~/ 7;
    
    if (totalWeeks < 0) totalWeeks = 0;
    if (progressWeeks < 0) progressWeeks = 0;
    
    if (mounted) {
      setState(() {
        _jobHuntingPeriod = '残り${totalWeeks}週（${progressWeeks}週進行）';
      });
    }
  }

  List<Widget> _buildUpcomingTasks(BuildContext context, List<MediumGoal> mediumGoals) {

    final List<Widget> upcomingTaskWidgets = [];
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final oneWeekFromNow = startOfToday.add(const Duration(days: 8));
    final List<Map<String, dynamic>> tasksToSort = [];

    for (var mGoal in mediumGoals) {
      if (mGoal.deadline != null &&
          !mGoal.deadline!.isBefore(startOfToday) &&
          mGoal.deadline!.isBefore(oneWeekFromNow)) {
        tasksToSort.add({'goal': mGoal, 'type': 'medium'});
      }
      for (var sGoal in mGoal.smallGoals) {
        if (!sGoal.isCompleted &&
            sGoal.deadline != null &&
            !sGoal.deadline!.isBefore(startOfToday) &&
            sGoal.deadline!.isBefore(oneWeekFromNow)) {
          tasksToSort.add({
            'goal': sGoal,
            'type': 'small',
            'parentTitle': mGoal.title,
          });
        }
      }
    }

    tasksToSort.sort(
      (a, b) => (a['goal'].deadline as DateTime).compareTo(
        b['goal'].deadline as DateTime,
      ),
    );

    for (var taskData in tasksToSort) {
      if (taskData['type'] == 'medium') {
        MediumGoal goal = taskData['goal'];
        upcomingTaskWidgets.add(
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: Text(goal.title),
            subtitle: Text(
              '期限: ${DateFormat('M/d(E)', 'ja').format(goal.deadline!)}',
            ),
          ),
        );
      } else if (taskData['type'] == 'small') {
        SmallGoal goal = taskData['goal'];
        String parentTitle = taskData['parentTitle'];
        upcomingTaskWidgets.add(
          ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: Text(goal.title),
            subtitle: Text(
              '$parentTitle / 期限: ${DateFormat('M/d(E)', 'ja').format(goal.deadline!)}',
            ),
          ),
        );
      }
    }
    if (upcomingTaskWidgets.isEmpty) {

      return [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('1週間以内に期限のタスクはありません。')),
        ),
      ];
// =======
//       return [const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text('1週間以内に期限のタスクはありません。')))];
// >>>>>>> main
    }
    return upcomingTaskWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('M月d日 (E)', 'ja').format(DateTime.now());

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- 1. ヘッダーエリア (本日の日付) ---
          Center(
            child: Text(today, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),

          // --- 2. ステータスエリア (残り就活週数) ---
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('就活期間', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(_jobHuntingPeriod, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
          // ★★★ 3. 立ち絵表示エリア (仮置き) ★★★
          // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
          Card(
            elevation: 2,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            child: Container(
              height: 200, // イラストの高さを確保
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'ここに立ち絵を配置予定',
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- 4. ナビゲーションエリア ---
          Row(

    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Consumer<GoalModel>(
        builder: (context, goalModel, child) {
          return Column(
            children: [
              Expanded(

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const FittedBox(
                    child: Text('ログイン'),

                  ),
                  onPressed: () => context.go('/login'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const FittedBox(
                    child: Text('カレンダー'),
// =======
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   child: Card(
//                     elevation: 4,
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '直近のタスク',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                           const Divider(),
//                           Expanded(
//                             child: ListView(
//                               children: _buildUpcomingTasks(
//                                 context,
//                                 goalModel.mediumGoals,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
// >>>>>>> main
                  ),
                  onPressed: () => context.go('/calendar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.gamepad_outlined),
                  label: const FittedBox(
                    child: Text('ゲーム'),
                  ),
                  onPressed: () => context.go('/game'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- 5.ダッシュボード ---
          Consumer<GoalModel>(
            builder: (context, goalModel, child) {
              return Card(
                elevation: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('直近のタスク', style: theme.textTheme.titleLarge),
                      const Divider(),
                      ..._buildUpcomingTasks(context, goalModel.mediumGoals),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
