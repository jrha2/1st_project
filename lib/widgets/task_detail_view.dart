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
        _buildHeader(), // 상단 헤더
        const Divider(height: 1),
        Expanded(
          child: _tasks.isEmpty
              ? const Center(child: Text('등록된 할 일이 없습니다.'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final taskModel = _tasks[index];
                    // GitHub의 TaskCardItem은 'task'라는 이름의 Map을 받습니다.
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

  // 기존에 _taskData를 참조하던 부분을 수정했습니다.
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
          // 전체 개수를 DB 리스트인 _tasks.length로 표시합니다.
          Text('전체 ${_tasks.length}개'),
        ],
      ),
    );
  }
}
