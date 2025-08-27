import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/shared/models/task.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja');
  }

  @override
  Widget build(BuildContext context) {
    final monthNum = DateFormat.M('ja').format(_currentDate); // 月(数字)
    final yearMonth = DateFormat.yMMMM('en').format(_currentDate); // 年/月

    final firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;
    final totalDays = lastDay.day;

    // 曜日行
    const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

    // 行リスト
    List<TableRow> rows = [];

    // 曜日ヘッダー
    rows.add(
      TableRow(
        children: List.generate(7, (i) {
          Color color =
              (i == 6) ? Colors.red : (i == 5 ? Colors.blue : Colors.black);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                days[i],
                style: GoogleFonts.robotoSlab(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }),
      ),
    );

    // 日付セル
    List<Widget> cells = [];
    for (int i = 0; i < (startWeekday == 0 ? 6 : startWeekday - 1); i++) {
      cells.add(Container()); // 前の空白
    }

    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(_currentDate.year, _currentDate.month, day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final isToday =
          DateTime.now().day == day &&
          DateTime.now().month == _currentDate.month &&
          DateTime.now().year == _currentDate.year;

      final isSunday = date.weekday == 7;
      final isSaturday = date.weekday == 6;

      cells.add(
        Consumer<GoalModel>(
          builder: (context, goalModel, child) {
            final todos = goalModel.getCalendarTasks()[dateStr] ?? [];
            return Container(
              height: 120, // ← ここで縦長に固定！
              decoration: BoxDecoration(
                color: isToday ? Colors.yellow.shade100 : null,
                border: Border.all(color: Colors.grey.shade400),
              ),
              padding: EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$day',
                    style: GoogleFonts.robotoSlab(
                      color:
                          isSunday
                              ? Colors.red
                              : isSaturday
                              ? Colors.blue
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children:
                          todos
                              .map(
                                (todo) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    todo,
                                    style: GoogleFonts.robotoSlab(fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    // 7列ごとに分割
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(
        TableRow(
          children: List.generate(
            7,
            (j) => i + j < cells.length ? cells[i + j] : Container(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          children: [
            Text(
              monthNum,
              style: GoogleFonts.robotoSlab(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 12),
            Text(
              yearMonth,
              style: GoogleFonts.robotoSlab(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.arrow_left), onPressed: _previousMonth),
          IconButton(icon: Icon(Icons.arrow_right), onPressed: _nextMonth),
        ],
      ),
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade400),
          children: rows,
        ),
      ),
    );
  }
}
