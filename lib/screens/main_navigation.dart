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

  double _sidebarWidth = 260.0;
  bool _isCollapsed = false;
  final double _minWidth = 180.0;
  final double _maxWidth = 450.0;
  final double _collapsedWidth = 70.0;

  // Microsoft To Do의 메인 테마 컬러 (연한 블루/퍼플 톤)
  final Color _primaryBlue = const Color(0xFF2564CF);
  final Color _sidebarBg = const Color(0xFFF3F2F1); // To Do 특유의 연회색 배경

  final List<Widget> _pages = [
    const TaskDetailView(),
    const Center(child: Text('캘린더 페이지')),
    const Center(child: Text('설정 페이지')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 메인 콘텐츠 영역은 순백색
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: _primaryBlue,
          unselectedItemColor: Colors.grey[600],
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: '할일',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: '캘린더',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: '설정',
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // 1. Microsoft To Do 스타일 사이드바
          SizedBox(
            width: _isCollapsed ? _collapsedWidth : _sidebarWidth,
            child: Container(
              color: _sidebarBg,
              child: ClipRect(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    // 접기/펼치기 버튼 (To Do의 햄버거 메뉴 느낌)
                    IconButton(
                      icon: Icon(
                        _isCollapsed ? Icons.menu : Icons.menu_open,
                        color: Colors.grey[700],
                      ),
                      onPressed: () =>
                          setState(() => _isCollapsed = !_isCollapsed),
                    ),
                    const SizedBox(height: 10),

                    // 상단 고정 스마트 리스트
                    _buildToMenuItem(
                      Icons.wb_sunny_outlined,
                      '할 일',
                      0,
                      color: Colors.amber[800],
                    ),
                    _buildToMenuItem(
                      Icons.calendar_today_outlined,
                      '모든 Task',
                      1,
                      color: _primaryBlue,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(height: 30, thickness: 0.8),
                    ),

                    // 프로젝트 계층 리스트
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (_isCollapsed) ...[
                              _buildCollapsedIcon(
                                Icons.format_list_bulleted,
                                _primaryBlue,
                              ),
                              _buildCollapsedIcon(
                                Icons.inventory_2_outlined,
                                Colors.grey[600]!,
                              ),
                            ] else ...[
                              // 계층 구조 시각화 (To Do 특유의 폰트와 간격)
                              Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  leading: Icon(
                                    Icons.format_list_bulleted,
                                    color: _primaryBlue,
                                    size: 22,
                                  ),
                                  title: const Text(
                                    '프로젝트 그룹',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  initiallyExpanded: true,
                                  children: [_buildSubItem('프로젝트')],
                                ),
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
          ),

          // 2. 세련된 구분선 (MouseRegion으로 커서 제어)
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
                width: 4,
                color: _sidebarBg,
                child: Center(
                  child: Container(width: 1, color: Colors.grey[300]), // 얇은 실선
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

  // To Do 스타일 메뉴 아이템
  Widget _buildToMenuItem(
    IconData icon,
    String label,
    int index, {
    Color? color,
  }) {
    bool isSelected = _selectedFolderIndex == index;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: color ?? Colors.grey[700], size: 22),
      title: _isCollapsed
          ? null
          : Text(
              label,
              style: TextStyle(
                color: isSelected ? _primaryBlue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
      selected: isSelected,
      selectedTileColor: Colors.white, // 선택되었을 때 배경색 변화
      onTap: () => setState(() => _selectedFolderIndex = index),
    );
  }

  // To Do 스타일 서브 아이템 (들여쓰기와 아이콘 크기 조절)
  Widget _buildSubItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: ListTile(
        leading: const Icon(Icons.chevron_right, size: 18), // 계층 표시 화살표
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildCollapsedIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
