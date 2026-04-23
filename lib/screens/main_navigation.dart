import 'package:flutter/material.dart';
import '../widgets/project_explorer.dart';
import '../widgets/task_detail_view.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  double _sidebarWidth = 320.0;
  bool _isSidebarVisible = true;
  String _selectedNode = "블록 조립";
  String? _selectedAssignee = "하진래";
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PMS Professional - Task Master'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () =>
              setState(() => _isSidebarVisible = !_isSidebarVisible),
        ),
        backgroundColor: Colors.indigo.shade50,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) => setState(() => _navIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.assignment), label: '태스크'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: '일정'),
          NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
      body: _navIndex == 0
          ? Row(
              children: [
                if (_isSidebarVisible)
                  SizedBox(
                    width: _sidebarWidth,
                    child: Container(
                      color: Colors.grey.shade50,
                      child: ProjectExplorerTree(
                        selectedNode: _selectedNode,
                        onNodeSelected: (node, assignee) => setState(() {
                          _selectedNode = node;
                          _selectedAssignee = assignee;
                        }),
                      ),
                    ),
                  ),
                if (_isSidebarVisible) _buildResizer(),
                Expanded(
                  child: TaskDetailView(
                    nodeName: _selectedNode,
                    assignee: _selectedAssignee,
                  ),
                ),
              ],
            )
          : Center(child: Text(_navIndex == 1 ? "일정 화면 준비 중" : "설정 화면 준비 중")),
    );
  }

  Widget _buildResizer() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sidebarWidth += details.delta.dx;
          _sidebarWidth = _sidebarWidth.clamp(180.0, 600.0);
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: Container(
          width: 16,
          color: Colors.transparent,
          child: Center(
            child: Container(width: 4, color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
