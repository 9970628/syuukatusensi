// lib/widgets/add_edit_small_goal_dialog.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sennsi_app/shared/models/task.dart';

class AddOrEditSmallGoalDialog extends StatefulWidget {
  final Function(String title, DateTime? deadline) onSave;
  final bool isEditMode;
  final SmallGoal? initialGoal;

  const AddOrEditSmallGoalDialog({ super.key, required this.onSave, this.isEditMode = false, this.initialGoal });

  @override
  State<AddOrEditSmallGoalDialog> createState() => _AddOrEditSmallGoalDialogState();
}

class _AddOrEditSmallGoalDialogState extends State<AddOrEditSmallGoalDialog> {
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