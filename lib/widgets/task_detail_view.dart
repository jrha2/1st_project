import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskDetailView extends StatefulWidget {
  final bool showOnlyImportant;
  const TaskDetailView({super.key, this.showOnlyImportant = false});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  // 샘플 데이터 (답글 및 메모 포함)
  final List<FullTaskModel> _allTasks = [
    FullTaskModel(
      title: '중고선 도입 체크리스트 검토',
      isImportant: true,
      dueDate: '2026-05-15',
      steps: [
        TaskStep(title: '선박 명세서 확인', isDone: true),
        TaskStep(title: '엔진 점검'),
      ],
      memo: '재무팀 협의 필요',
      comments: [
        TaskComment(
          author: '김대리',
          content: '해사관리팀 협의 필요 (4월 25일)',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    ),
  ];

  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedTasks = widget.showOnlyImportant
        ? _allTasks.where((t) => t.isImportant).toList()
        : _allTasks;

    return Container(
      color: const Color(0xFFFAF9F8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 20, top: 20),
            child: Text(
              widget.showOnlyImportant ? '즐겨찾기' : '1주 내 할 일',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2564CF),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedTasks.length,
              itemBuilder: (context, index) =>
                  _buildTaskCard(displayedTasks[index]),
            ),
          ),
          _buildAddTaskButton(),
        ],
      ),
    );
  }

  Widget _buildTaskCard(FullTaskModel task) {
    _memoController.text = task.memo;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(left: 12, right: 4),
        leading: IconButton(
          icon: Icon(
            task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          ),
          color: task.isDone ? const Color(0xFF2564CF) : Colors.grey,
          onPressed: () => setState(() => task.isDone = !task.isDone),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Wrap(
          children: [
            IconButton(
              icon: Icon(
                task.isImportant ? Icons.star : Icons.star_border,
                color: task.isImportant ? Colors.amber : Colors.grey,
              ),
              onPressed: () =>
                  setState(() => task.isImportant = !task.isImportant),
            ),
            const Icon(Icons.expand_more),
            const SizedBox(width: 8),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 12),
                // 기한/알람/담당자 칩
                Row(
                  children: [
                    _buildChip(Icons.calendar_month, task.dueDate ?? '기한'),
                    _buildChip(Icons.notifications, task.alarm ?? '알람'),
                    _buildChip(Icons.person, task.assignee ?? '담당자'),
                  ],
                ),
                const SizedBox(height: 24),

                // 세부 항목 섹션
                _buildSectionTitle(
                  '세부 항목',
                  onAdd: () =>
                      setState(() => task.steps.add(TaskStep(title: '새 항목'))),
                ),
                ...task.steps.asMap().entries.map(
                  (e) => _buildStepItem(
                    e.value,
                    () => setState(() => task.steps.removeAt(e.key)),
                  ),
                ),

                const SizedBox(height: 32),

                // 메모 섹션 (저장 버튼만 포함)
                _buildSectionTitle('메모 및 답글'),
                const SizedBox(height: 8),
                _buildMemoBox(task),

                const SizedBox(height: 12),

                // 파일 첨부 섹션 (복원됨)
                _buildFileAttachmentBar(),

                const SizedBox(height: 24),
                const Divider(),

                // 답글 섹션
                _buildReplyThread(task),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 구성 요소 위젯 함수들 ---

  Widget _buildSectionTitle(String title, {VoidCallback? onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        if (onAdd != null)
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            onPressed: onAdd,
          ),
      ],
    );
  }

  Widget _buildMemoBox(FullTaskModel task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2F1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          TextField(
            controller: _memoController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: '메모를 남기세요...',
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                setState(() => task.memo = _memoController.text);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('메모가 저장되었습니다.')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2564CF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('저장', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileAttachmentBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.add, color: Color(0xFF2564CF), size: 18),
          const SizedBox(width: 8),
          const Text(
            '파일 추가',
            style: TextStyle(
              color: Color(0xFF2564CF),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          _buildFileTile('사양서_rev1.pdf'),
          _buildFileTile('도면_스크린샷.png'),
        ],
      ),
    );
  }

  Widget _buildFileTile(String name) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 14,
            color: Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(name, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 4),
          const Icon(Icons.close, size: 12, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildReplyThread(FullTaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '답글',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        ...task.comments.map(
          (comment) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, size: 16, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.author,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MM/dd HH:mm').format(comment.timestamp),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.content,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // 답글 입력란
        Row(
          children: [
            const Icon(
              Icons.add_comment_outlined,
              size: 18,
              color: Color(0xFF2564CF),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '답글 추가...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 13),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(
                      () => task.comments.add(
                        TaskComment(
                          author: '나',
                          content: value,
                          timestamp: DateTime.now(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepItem(TaskStep step, VoidCallback onDelete) {
    return Row(
      children: [
        Checkbox(
          value: step.isDone,
          onChanged: (v) => setState(() => step.isDone = v!),
          activeColor: const Color(0xFF2564CF),
        ),
        Expanded(
          child: Text(
            step.title,
            style: TextStyle(
              fontSize: 14,
              color: step.isDone ? Colors.grey : Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 14, color: Colors.grey),
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return ListTile(
      leading: const Icon(Icons.add, color: Color(0xFF2564CF)),
      title: const Text(
        '작업 추가',
        style: TextStyle(color: Color(0xFF2564CF), fontWeight: FontWeight.w500),
      ),
      onTap: () {},
    );
  }
}
