import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskDetailView extends StatefulWidget {
  final TaskModel? task;
  final VoidCallback onSave;
  final VoidCallback onDelete; // 삭제 콜백 추가
  final TextEditingController titleController;
  final TextEditingController contentController;

  const TaskDetailView({
    super.key,
    this.task,
    required this.onSave,
    required this.onDelete,
    required this.titleController,
    required this.contentController,
  });

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  // 삭제 확인 팝업창
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("항목 삭제"),
          content: const Text("정말로 이 항목을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                widget.onDelete(); // 부모 위젯의 삭제 함수 실행
              },
              child: const Text("삭제", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.titleController,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '제목 없음',
                    ),
                  ),
                ),
                // 삭제 버튼
                TextButton.icon(
                  onPressed: _showDeleteDialog,
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  label: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
                ),
                const SizedBox(width: 12),
                // 저장 버튼
                ElevatedButton.icon(
                  onPressed: widget.onSave,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('저장'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextField(
                controller: widget.contentController,
                maxLines: null,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '여기에 메모를 작성하세요...',
                ),
              ),
            ),
          ),
          // 하단 영역 (기존 UI 유지)
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.attach_file, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text("파일 첨부 바", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text("답글", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}