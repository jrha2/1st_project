import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'smart_alarm_dialog.dart';

class TaskCardItem extends StatefulWidget {
  final Map<String, dynamic> task;
  final VoidCallback onRefresh;

  const TaskCardItem({super.key, required this.task, required this.onRefresh});

  @override
  State<TaskCardItem> createState() => _TaskCardItemState();
}

class _TaskCardItemState extends State<TaskCardItem> {
  @override
  Widget build(BuildContext context) {
    var task = widget.task;
    bool isEnabled = (task['isAlarmEnabled'] ?? false) as bool;
    String alarmStatus = isEnabled
        ? DateFormat('MM-dd HH:mm').format(task['alarmDate'])
        : "알람 꺼짐";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        initiallyExpanded: task['isExpanded'] ?? false,
        onExpansionChanged: (v) => setState(() => task['isExpanded'] = v),
        leading: Checkbox(
          // 만약 데이터가 없으면(null) 거짓(false)으로 처리하라는 뜻입니다.
          value: task['isCompleted'] == 1 || task['isCompleted'] == true,
          onChanged: (v) {
            // 여기에 체크 박스 변경 로직 추가 예정
          },
        ),
        title: Text(
          task['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _buildSubtitle(context, isEnabled, alarmStatus, task),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSubTaskSection(task),
                const SizedBox(height: 15),
                _buildMemoSection(task),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(
    BuildContext context,
    bool isEnabled,
    String alarmStatus,
    Map<String, dynamic> task,
  ) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // task['dueDate']가 비어있으면 '기한 없음'이라고 표시하고, 있으면 날짜를 보여줍니다.
        Text(
          task['dueDate'] != null
              ? "기한: ${DateFormat('yyyy-MM-dd').format(task['dueDate'])}"
              : "기한: 없음",
        ),

        const SizedBox(width: 12),
        Icon(
          Icons.notifications_active,
          size: 14,
          color: isEnabled ? Colors.indigo : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          alarmStatus,
          style: TextStyle(
            fontSize: 12,
            color: isEnabled ? Colors.indigo : Colors.grey,
            fontWeight: isEnabled ? FontWeight.bold : null,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 20),
          ),
          onPressed: () async {
            // SmartAlarmDialog 호출 로직
            await showDialog(
              context: context,
              builder: (context) => SmartAlarmDialog(task: task),
            );
            setState(() {}); // 알람 설정 후 UI 갱신
            widget.onRefresh();
          },
          child: const Text("알람 설정", style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildSubTaskSection(Map<String, dynamic> task) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "하위 항목",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // 하위 항목 추가 로직 (필요 시 구현)
              },
              icon: const Icon(Icons.add_circle_outline, size: 14),
              label: const Text("추가", style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        ...((task['subTasks'] ?? []) as List).asMap().entries.map((entry) {
          int idx = entry.key;
          var st = entry.value;
          return Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Checkbox(
                  value: st['done'],
                  onChanged: (v) {
                    setState(() => st['done'] = v);
                    widget.onRefresh();
                  },
                ),
              ),
              Expanded(
                child: Text(
                  st['label'],
                  style: TextStyle(
                    fontSize: 13,
                    decoration: st['done'] ? TextDecoration.lineThrough : null,
                    color: st['done'] ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                onPressed: () {
                  setState(() => (task['subTasks'] as List).removeAt(idx));
                  widget.onRefresh();
                },
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildMemoSection(Map<String, dynamic> task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "메모 및 의견",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: task['memo']),
                onChanged: (v) => task['memo'] = v,
                style: const TextStyle(fontSize: 13),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "메모를 입력하세요...",
                  contentPadding: EdgeInsets.all(12),
                  border: InputBorder.none,
                ),
              ),
              if ((task['comments'] as List? ?? []).isNotEmpty)
                _buildCommentsList(task),
              _buildCommentInput(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsList(Map<String, dynamic> task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const Divider(height: 1),
          const SizedBox(height: 10),
          ...(task['comments'] as List).map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      c['author'][0],
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c['author'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(c['text'], style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: "의견 추가...",
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_comment, size: 20, color: Colors.indigo),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
