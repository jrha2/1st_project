import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'smart_alarm_dialog.dart';

class TaskDetailView extends StatefulWidget {
  final String nodeName;
  final String? assignee;
  const TaskDetailView({super.key, required this.nodeName, this.assignee});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  final Map<String, List<Map<String, dynamic>>> _taskData = {
    "블록 조립": [
      {
        "title": "선미 블록 용접 검사",
        "dueDate": DateTime(2026, 5, 10),
        "alarmDate": DateTime(2026, 4, 22, 9, 0),
        "isAlarmEnabled": true,
        "done": false,
        "isExpanded": true,
        "memo": "용접 부위 비파괴 검사(NDT) 결과 확인 필요",
        "subTasks": [
          {"label": "용접봉 입고 확인", "done": true},
          {"label": "검사관 스케줄 협의", "done": false},
        ],
        "comments": [
          {"author": "Dado", "text": "스케줄 확인했습니다.", "time": "오전 10:30"},
        ],
      },
    ],
  };

  void _showSmartAlarmDialog(Map<String, dynamic> task) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SmartAlarmDialog(task: task),
    );

    if (result != null) {
      setState(() {
        task['isAlarmEnabled'] = result['isEnabled'];
        task['alarmDate'] = result['date'];
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
            itemBuilder: (context, index) =>
                _buildAdvancedTaskRow(tasks[index]),
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
          if (widget.assignee != null) ...[
            const SizedBox(width: 12),
            _buildAssigneeBadge(),
          ],
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Task 추가"),
          ),
        ],
      ),
    );
  }

  Widget _buildAssigneeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Text(
        "담당자: ${widget.assignee}",
        style: TextStyle(
          fontSize: 14,
          color: Colors.indigo.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAdvancedTaskRow(Map<String, dynamic> task) {
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
          value: task['done'],
          onChanged: (v) => setState(() => task['done'] = v),
        ),
        title: Text(
          task['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _buildTaskSubtitle(isEnabled, alarmStatus, task),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSubTaskHeader(),
                ..._buildSubTaskList(task),
                const SizedBox(height: 15),
                _buildMemoSection(task),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 이하 서브 컴포넌트 로직 (이미지 UI와 동일하게 구성) ---
  Widget _buildTaskSubtitle(
    bool isEnabled,
    String alarmStatus,
    Map<String, dynamic> task,
  ) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("기한: ${DateFormat('yyyy-MM-dd').format(task['dueDate'])}"),
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
          onPressed: () => _showSmartAlarmDialog(task),
          child: const Text("알람 설정", style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildSubTaskHeader() {
    return Row(
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
          onPressed: () {},
          icon: const Icon(Icons.add_circle_outline, size: 14),
          label: const Text("추가", style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  List<Widget> _buildSubTaskList(Map<String, dynamic> task) {
    return (task['subTasks'] as List).asMap().entries.map((entry) {
      int idx = entry.key;
      var st = entry.value;
      return Row(
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: Checkbox(
              value: st['done'],
              onChanged: (v) => setState(() => st['done'] = v),
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
            onPressed: () =>
                setState(() => (task['subTasks'] as List).removeAt(idx)),
          ),
        ],
      );
    }).toList();
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
              if ((task['comments'] as List).isNotEmpty)
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
                children: [
                  CircleAvatar(
                    radius: 10,
                    child: Text(
                      c['author'][0],
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${c['author']}: ${c['text']}",
                      style: const TextStyle(fontSize: 12),
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
              decoration: InputDecoration(
                hintText: "의견 추가...",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_comment, color: Colors.indigo),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
