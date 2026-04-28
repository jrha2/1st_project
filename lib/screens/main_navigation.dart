import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // 하단 바 (할일, 캘린더, 설정)
  int _selectedFolderIndex = 1; // 좌측 메뉴 (계획된, 전체 등)

  double _sidebarWidth = 250.0;
  bool _isCollapsed = false;
  final double _minWidth = 150.0;
  final double _maxWidth = 500.0;
  final double _collapsedWidth = 64.0;

  // 하단 바 아이템 개수(3개)와 동일하게 페이지 구성
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
          SizedBox(
            width: _isCollapsed ? _collapsedWidth : _sidebarWidth,
            child: Container(
              color: Colors.grey[50],
              // ClipRect는 자식 위젯이 지정된 너비 밖으로 삐져나가지 않게 "칼로 자르듯" 막아줍니다.
              child: ClipRect(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    IconButton(
                      icon: Icon(
                        _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                      ),
                      onPressed: () =>
                          setState(() => _isCollapsed = !_isCollapsed),
                    ),
                    const SizedBox(height: 10),

                    // 메뉴 항목들 (함수 내부에서 에러 방지 처리 완료)
                    _buildMenuItem(Icons.upcoming, '계획된 Task', 0),
                    _buildMenuItem(Icons.list_alt, '전체 Task', 1),

                    const Divider(),

                    // 접히지 않았을 때만 리스트 뷰를 렌더링
                    if (!_isCollapsed)
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
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
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 2. 드래그 조절 바
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

  Widget _buildMenuItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      // 접혔을 때는 글자를 완전히 없애서 공간 에러를 원천 차단합니다.
      title: _isCollapsed
          ? null
          : Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
      selected: _selectedFolderIndex == index,
      onTap: () => setState(() => _selectedFolderIndex = index),
    );
  }
}
