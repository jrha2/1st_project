import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/db_helper.dart';
import 'task_card_item.dart';

class TaskDetailView extends StatefulWidget {
  const TaskDetailView({super.key});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  final DBHelper _dbHelper = DBHelper();
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    final data = await _dbHelper.getTasks();
    setState(() {
      _tasks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const Divider(height: 1),
        Expanded(
          child: _tasks.isEmpty
              ? const Center(child: Text('등록된 할 일이 없습니다.'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final taskModel = _tasks[index];
                    return TaskCardItem(
                      task: taskModel.toMap(),
                      onRefresh: _refreshTasks,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '할 일 목록',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // _taskData 대신 실제 DB 데이터인 _tasks.length를 사용합니다.
          Text('전체 ${_tasks.length}개'),
        ],
      ),
    );
  }
}
