import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/db_helper.dart';
import '../widgets/task_detail_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  List<TaskModel> _tasks = [];
  TaskModel? _selectedTask;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    final data = await DbHelper.instance.getAllTasks();
    setState(() {
      _tasks = data;
    });
  }

  // 삭제 실행 함수
  Future<void> _deleteTask() async {
    if (_selectedTask == null) return;

    // DB에서 삭제 (신규 생성 중인 항목은 id가 없으므로 바로 UI만 초기화)
    if (_selectedTask!.id != null) {
      await DbHelper.instance.deleteTask(_selectedTask!.id!);
    }

    if (!mounted) return;

    await _refreshTasks();
    setState(() {
      _selectedTask = null;
      _titleController.clear();
      _contentController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('성공적으로 삭제되었습니다.')),
    );
  }

  Future<void> _saveTask() async {
    if (_selectedTask == null) return;
    if (_titleController.text.trim().isEmpty) return;

    final updatedTask = _selectedTask!.copyWith(
      title: _titleController.text,
      description: _contentController.text,
    );

    if (updatedTask.id == null) {
      await DbHelper.instance.insertTask(updatedTask);
    } else {
      await DbHelper.instance.updateTask(updatedTask);
    }

    if (!mounted) return;
    await _refreshTasks();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('저장되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final t = _tasks[index];
                      return Padding(
                        padding: EdgeInsets.only(left: (t.level - 1) * 16.0),
                        child: ListTile(
                          dense: true,
                          leading: Icon(_getIconForLevel(t.level), size: 16),
                          title: Text(t.title),
                          selected: _selectedTask?.id == t.id,
                          onTap: () {
                            setState(() {
                              _selectedTask = t;
                              _titleController.text = t.title;
                              _contentController.text = t.description ?? '';
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                _buildBottomButtons(),
              ],
            ),
          ),
          Expanded(
            child: _selectedTask == null
                ? const Center(child: Text("항목을 선택해주세요."))
                : TaskDetailView(
                    task: _selectedTask,
                    onSave: _saveTask,
                    onDelete: _deleteTask, // 삭제 함수 전달
                    titleController: _titleController,
                    contentController: _contentController,
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLevel(int level) {
    switch (level) {
      case 1: return Icons.folder_copy;
      case 2: return Icons.folder;
      case 3: return Icons.account_tree;
      case 4: return Icons.format_list_bulleted;
      default: return Icons.check_circle_outline;
    }
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _actionButton("새 프로젝트 그룹", 1),
          _actionButton("새 프로젝트", 2),
          _actionButton("새 업무 그룹", 3),
          _actionButton("새 목록", 4),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _actionButton(String label, int level) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            _selectedTask = TaskModel(title: "새 $label", level: level);
            _titleController.text = _selectedTask!.title;
            _contentController.clear();
          });
        },
        icon: const Icon(Icons.add, size: 18),
        label: Text(label),
        style: TextButton.styleFrom(alignment: Alignment.centerLeft),
      ),
    );
  }
}