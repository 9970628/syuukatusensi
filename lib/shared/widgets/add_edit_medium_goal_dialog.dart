// lib/widgets/add_edit_medium_goal_dialog.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sennsi_app/shared/models/task.dart';

class AddOrEditMediumGoalDialog extends StatefulWidget {
  final Function(String title, DateTime? deadline) onSave;
  final bool isEditMode;
  final MediumGoal? initialGoal;

  const AddOrEditMediumGoalDialog({ super.key, required this.onSave, this.isEditMode = false, this.initialGoal });

  @override
  State<AddOrEditMediumGoalDialog> createState() => _AddOrEditMediumGoalDialogState();
}

class _AddOrEditMediumGoalDialogState extends State<AddOrEditMediumGoalDialog> {
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
      title: Text(widget.isEditMode ? '中目標の編集' : '中目標の追加'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _titleController, decoration: const InputDecoration(hintText: '目標のタイトル'), autofocus: true),
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