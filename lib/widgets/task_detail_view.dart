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
          // --- 여기 아래 버튼을 잠시 추가해서 테스트해봅시다 ---
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.blue),
            onPressed: () async {
              // 임시 데이터 생성
              final testTask = TaskModel(
                title: "드디어 첫 데이터!",
                memo: "DB에 잘 들어갔는지 확인용입니다.",
              );
              // DB에 저장
              await _dbHelper.insertTask(testTask);
              // 화면 새로고침
              _refreshTasks();
            },
          ),
          // ----------------------------------------------
          Text('전체 ${_tasks.length}개'),
        ],
      ),
    );
  }
}
