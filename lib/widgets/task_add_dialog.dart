import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskAddDialog extends StatefulWidget {
  const TaskAddDialog({super.key});

  @override
  State<TaskAddDialog> createState() => _TaskAddDialogState();
}

class _TaskAddDialogState extends State<TaskAddDialog> {
  String _newTitle = "";
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("새 태스크 추가"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "태스크 제목"),
            onChanged: (v) => _newTitle = v,
            autofocus: true,
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text("마감 기한"),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("취소"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_newTitle.trim().isEmpty) return;
            Navigator.pop(context, {
              'title': _newTitle,
              'dueDate': _selectedDate,
            });
          },
          child: const Text("추가"),
        ),
      ],
    );
  }
}
