import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();
  final Map<String, List<String>> _todoMap = {}; // ToDoを日付別に保持

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

  // void _addTodo() {
  //   String input = '';
  //   final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('ToDo追加'),
  //       content: TextField(
  //         autofocus: true,
  //         onChanged: (value) => input = value,
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             if (input.isNotEmpty) {
  //               setState(() {
  //                 _todoMap[todayStr] = (_todoMap[todayStr] ?? [])..add(input);
  //               });
  //             }
  //             Navigator.pop(context);
  //           },
  //           child: Text('追加'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  List<Widget> _buildDaysOfWeek() {
    const days = ['日', '月', '火', '水', '木', '金', '土'];
    return List.generate(7, (i) {
      Color color = (i == 0)
          ? Colors.red
          : (i == 6)
              ? Colors.blue
              : Colors.black;
      return Center(child: Text(days[i], style: TextStyle(color: color)));
    });
  }

  List<Widget> _buildCalendarCells() {
    final firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;
    final totalDays = lastDay.day;

    List<Widget> cells = [];

    for (int i = 0; i < startWeekday; i++) {
      cells.add(Container());
    }

    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(_currentDate.year, _currentDate.month, day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final todos = _todoMap[dateStr] ?? [];
      final isToday = DateTime.now().day == day &&
          DateTime.now().month == _currentDate.month &&
          DateTime.now().year == _currentDate.year;

      final isSunday = date.weekday % 7 == 0;
      final isSaturday = date.weekday == 6;

      cells.add(Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isToday ? Colors.yellow.shade100 : null,
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: isSunday
                    ? Colors.red
                    : isSaturday
                        ? Colors.blue
                        : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...todos.map((todo) => Container(
                  margin: EdgeInsets.only(top: 2),
                  padding:
                      EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  color: Colors.cyan.shade100,
                  child: Text(todo, style: TextStyle(fontSize: 10)),
                )),
          ],
        ),
      ));
    }

    return cells;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja');
  }

  @override
  Widget build(BuildContext context) {
    final monthStr = DateFormat.yMMMM('ja').format(_currentDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('カレンダー'),
        // actions: [
        //   IconButton(icon: Icon(Icons.add), onPressed: _addTodo),
        // ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: Icon(Icons.arrow_left), onPressed: _previousMonth),
              Text(monthStr,
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.arrow_right), onPressed: _nextMonth),
            ],
          ),
          Divider(),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            childAspectRatio: 1.5,
            physics: NeverScrollableScrollPhysics(),
            children: _buildDaysOfWeek(),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              childAspectRatio: 0.9,
              children: _buildCalendarCells(),
            ),
          ),
        ],
      ),
    );
  }
}
