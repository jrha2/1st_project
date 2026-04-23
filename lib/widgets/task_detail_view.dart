import 'package:flutter/material.dart';
import 'task_add_dialog.dart';
import 'task_card_item.dart';

class TaskDetailView extends StatefulWidget {
  final String nodeName;
  final String? assignee;
  const TaskDetailView({super.key, required this.nodeName, this.assignee});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  final Map<String, List<Map<String, dynamic>>> _taskData = {
    "블록 조립": [/* 초기 데이터 */],
  };

  void _addNewTask() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const TaskAddDialog(),
    );

    if (result != null) {
      setState(() {
        if (!_taskData.containsKey(widget.nodeName))
          _taskData[widget.nodeName] = [];
        _taskData[widget.nodeName]!.add({
          "title": result['title'],
          "dueDate": result['dueDate'],
          "alarmDate": (result['dueDate'] as DateTime).subtract(
            const Duration(days: 1),
          ),
          "isAlarmEnabled": false,
          "done": false,
          "isExpanded": true,
          "memo": "",
          "subTasks": [],
          "comments": [],
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tasks = _taskData[widget.nodeName] ?? [];

    return Column(
      children: [
        _buildHeader(),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => TaskCardItem(
              task: tasks[index],
              onRefresh: () => setState(() {}),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            widget.nodeName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _addNewTask,
            icon: const Icon(Icons.add),
            label: const Text("Task 추가"),
          ),
        ],
      ),
    );
  }
}
