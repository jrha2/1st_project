import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  int _selectedFolderIndex = 1;

  double _sidebarWidth = 250.0;
  bool _isCollapsed = false;
  final double _minWidth = 150.0;
  final double _maxWidth = 500.0;
  final double _collapsedWidth = 60.0; // 접혔을 때 아이콘이 보일 정도의 최소 간격

  final List<Widget> _pages = [
    const TaskDetailView(),
    const Center(child: Text('캘린더 페이지')),
    const Center(child: Text('설정 페이지')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: '할일',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '캘린더',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
      body: Row(
        children: [
          // 1. 좌측 메뉴 영역
          Container(
            width: _isCollapsed ? _collapsedWidth : _sidebarWidth,
            color: Colors.grey[50],
            child: Column(
              children: [
                const SizedBox(height: 10),
                // 접기/펼치기 버튼
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Icon(
                      _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    ),
                    onPressed: () =>
                        setState(() => _isCollapsed = !_isCollapsed),
                  ),
                ),
                // 메뉴 항목들 (접혔을 때는 아이콘만, 펼쳐졌을 때는 텍스트까지)
                _buildMenuItem(Icons.upcoming, '계획된 Task', 0),
                _buildMenuItem(Icons.list_alt, '전체 Task', 1),
                const Divider(),
                if (!_isCollapsed)
                  Expanded(
                    child: ListView(
                      children: [
                        ExpansionTile(
                          leading: const Icon(
                            Icons.folder_copy,
                            color: Colors.blue,
                          ),
                          title: const Text(
                            '프로젝트 그룹',
                            overflow: TextOverflow.ellipsis,
                          ),
                          initiallyExpanded: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: ExpansionTile(
                                leading: const Icon(Icons.assignment_outlined),
                                title: const Text(
                                  '프로젝트',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.folder_outlined,
                                      ),
                                      title: const Text(
                                        '그룹',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // 2. 커서가 바뀌는 드래그 조절 바
          MouseRegion(
            cursor: _isCollapsed
                ? SystemMouseCursors.basic
                : SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                if (_isCollapsed) return;
                setState(() {
                  _sidebarWidth += details.delta.dx;
                  if (_sidebarWidth < _minWidth) _sidebarWidth = _minWidth;
                  if (_sidebarWidth > _maxWidth) _sidebarWidth = _maxWidth;
                });
              },
              child: Container(
                width: 6,
                color: Colors.grey[300],
                child: Center(
                  child: !_isCollapsed
                      ? const Icon(
                          Icons.drag_handle,
                          size: 12,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
            ),
          ),

          // 3. 우측 콘텐츠 영역
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  // 메뉴 아이템을 만드는 도구 (접힘 상태 대응)
  Widget _buildMenuItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      title: _isCollapsed ? null : Text(label, overflow: TextOverflow.ellipsis),
      selected: _selectedFolderIndex == index,
      onTap: () => setState(() => _selectedFolderIndex = index),
    );
  }
}
