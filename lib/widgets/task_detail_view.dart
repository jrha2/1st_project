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

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새로운 할 일 추가'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: '할 일 제목을 입력하세요'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final newTask = TaskModel(
                  title: titleController.text,
                  memo: "새로 추가된 할 일입니다.", // 나중엔 메모 입력도 추가할게요!
                );
                await _dbHelper.insertTask(newTask);
                _refreshTasks(); // 목록 새로고침
                if (!mounted) return;
                Navigator.pop(context); // 다이얼로그 닫기
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
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
            icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
            onPressed: () {
              _showAddTaskDialog(context); // 입력 다이얼로그 호출
            },
          ),

          // ----------------------------------------------
          Text('전체 ${_tasks.length}개'),
        ],
      ),
    );
  }
}
