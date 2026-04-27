import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCardItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onRefresh;

  const TaskCardItem({super.key, required this.task, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    // 1. 데이터 안전성 확보 (Null 대비 기본값 설정)
    final String title = task['title'] ?? '제목 없음';
    final String memo = task['memo'] ?? '';
    final bool isCompleted =
        task['isCompleted'] == 1 || task['isCompleted'] == true;
    final List subTasks = task['subTasks'] as List? ?? [];
    final List comments = task['comments'] as List? ?? [];
    final double progress = (task['progress'] ?? 0).toDouble();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        // 체크박스 에러 방지
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) {
            // TODO: 업데이트 로직 연결 예정
          },
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            // 2. 날짜 에러 방지
            if (task['dueDate'] != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "기한: ${DateFormat('yyyy-MM-dd').format(task['dueDate'] is String ? DateTime.parse(task['dueDate']) : task['dueDate'])}",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            Text(
              "진행률: ${(progress * 100).toInt()}%",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (memo.isNotEmpty) ...[
                  Text(memo, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                ],

                // 3. 서브 태스크 에러 방지 (괄호 및 타입 체크 완료)
                if (subTasks.isNotEmpty) ...[
                  const Text(
                    "하위 할 일",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...subTasks.asMap().entries.map((entry) {
                    final subTask = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Icon(
                            subTask['isCompleted'] == 1
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text(subTask['title'] ?? ''),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // 4. 댓글 에러 방지
                if (comments.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    "댓글",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...comments.map(
                    (comment) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        comment['author'] ?? '익명',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(comment['content'] ?? ''),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
