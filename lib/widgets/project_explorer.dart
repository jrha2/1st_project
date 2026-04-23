import 'package:flutter/material.dart';

class ProjectExplorerTree extends StatelessWidget {
  final String selectedNode;
  final Function(String, String?) onNodeSelected;

  const ProjectExplorerTree({
    super.key,
    required this.selectedNode,
    required this.onNodeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            "프로젝트 그룹: 선박 건조",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ),
        _buildTreeItem(
          context: context,
          icon: Icons.directions_boat,
          label: "PAN SKY (210K)",
          level: 0,
          children: [
            _buildTreeItem(
              context: context,
              icon: Icons.folder,
              label: "A. 선체 공정",
              level: 1,
              children: [
                _buildTreeItem(
                  context: context,
                  icon: Icons.list_alt,
                  label: "블록 조립",
                  level: 2,
                  assignee: "하진래",
                ),
                _buildTreeItem(
                  context: context,
                  icon: Icons.list_alt,
                  label: "도장 공정",
                  level: 2,
                  assignee: "김철수",
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTreeItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int level,
    String? assignee,
    List<Widget>? children,
  }) {
    final bool isSelected = selectedNode == label;

    return Column(
      children: [
        ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.only(
            left: 16.0 * level + 12.0,
            right: 8.0,
          ),
          leading: Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.indigo : Colors.grey.shade600,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.indigo : Colors.black87,
            ),
          ),
          // 우측 더보기 버튼에 이전의 풍부한 메뉴를 적용
          trailing: _buildFullPopupMenu(label),
          selected: isSelected,
          onTap: () => onNodeSelected(label, assignee),
        ),
        if (children != null) ...children,
      ],
    );
  }

  // main_backup.dart의 메뉴 구성을 그대로 가져온 팝업 메뉴
  Widget _buildFullPopupMenu(String label) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 16),
      tooltip: "메뉴",
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => debugPrint("$label 복사"),
          child: const Row(
            children: [
              Icon(Icons.copy, size: 18),
              SizedBox(width: 8),
              Text("복사"),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => debugPrint("$label 신규"),
          child: const Row(
            children: [
              Icon(Icons.add, size: 18),
              SizedBox(width: 8),
              Text("신규"),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => debugPrint("$label 붙여넣기"),
          child: const Row(
            children: [
              Icon(Icons.paste, size: 18),
              SizedBox(width: 8),
              Text("붙여넣기"),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => debugPrint("$label 삭제"),
          child: const Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text("삭제", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
