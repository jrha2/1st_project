import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // 하단 탭 인덱스
  int _selectedFolderIndex = 1; // 좌측 메뉴 인덱스

  double _sidebarWidth = 250.0;
  bool _isCollapsed = false;
  final double _minWidth = 160.0;
  final double _maxWidth = 500.0;
  final double _collapsedWidth = 70.0; // 접혔을 때 아이콘이 충분히 보일 너비

  final List<Widget> _pages = [
    const TaskDetailView(),
    const Center(child: Text('캘린더 페이지')),
    const Center(child: Text('설정 페이지')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 하단 네비게이션 바
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

      // 2. 메인 바디
      body: Row(
        children: [
          // [좌측 메뉴 영역]
          SizedBox(
            width: _isCollapsed ? _collapsedWidth : _sidebarWidth,
            child: Container(
              color: Colors.grey[50],
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // 접기/펼치기 토글 버튼
                  IconButton(
                    icon: Icon(
                      _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    ),
                    onPressed: () =>
                        setState(() => _isCollapsed = !_isCollapsed),
                  ),
                  const SizedBox(height: 10),

                  // 고정 메뉴 (계획된, 전체)
                  _buildMenuItem(Icons.upcoming, '계획된 Task', 0),
                  _buildMenuItem(Icons.list_alt, '전체 Task', 1),

                  const Divider(),

                  // 프로젝트 계층 리스트 영역
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_isCollapsed) ...[
                            // 접혔을 때: 아이콘만 세로로 나열
                            _buildCollapsedIcon(Icons.folder_copy, Colors.blue),
                            _buildCollapsedIcon(
                              Icons.assignment_outlined,
                              Colors.grey,
                            ),
                            _buildCollapsedIcon(
                              Icons.folder_outlined,
                              Colors.grey,
                            ),
                          ] else ...[
                            // 펼쳐졌을 때: 트리 구조 노출
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
                                    leading: const Icon(
                                      Icons.assignment_outlined,
                                    ),
                                    title: const Text(
                                      '프로젝트',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // [중앙 드래그 조절 바]
          MouseRegion(
            cursor: _isCollapsed
                ? SystemMouseCursors.basic
                : SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
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

          // [우측 콘텐츠 영역]
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  // 메뉴 아이템 빌더 (펼침/접힘 대응)
  Widget _buildMenuItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      title: _isCollapsed
          ? null
          : Text(label, overflow: TextOverflow.clip, softWrap: false),
      selected: _selectedFolderIndex == index,
      onTap: () => setState(() => _selectedFolderIndex = index),
    );
  }

  // 접혔을 때 보여줄 아이콘 전용 위젯
  Widget _buildCollapsedIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
