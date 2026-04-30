import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  double _sidebarWidth = 260.0; // 조절 가능한 너비 상태
  int _selectedIndex = 1;
  bool _isExpanded = true;

  final List<Widget> _pages = [
    const TaskDetailView(showOnlyImportant: true),
    const TaskDetailView(showOnlyImportant: false),
    const Center(child: Text('설정')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // [사이드바 영역]
          SizedBox(
            width: _sidebarWidth,
            child: Container(
              color: const Color(0xFFF3F2F1),
              child: Column(
                children: [
                  const SizedBox(height: 52),
                  _buildMenuHeader(),
                  const SizedBox(height: 16),

                  // 1. 이름 변경된 스마트 목록
                  _buildMenuItem(0, Icons.star_border, Icons.star, '즐겨찾기'),
                  _buildMenuItem(
                    1,
                    Icons.wb_sunny_outlined,
                    Icons.wb_sunny,
                    '1주 내 할 일',
                  ),
                  _buildMenuItem(1, Icons.home_outlined, Icons.home, '모든 업무'),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Divider(height: 1, thickness: 0.5),
                  ),

                  // 2. 5단계 계층 구조 (내 목록)
                  if (_isExpanded)
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _buildTreeItem(
                            Icons.grid_view,
                            '모든 프로젝트 그룹',
                            depth: 0,
                          ),
                          _buildTreeItem(
                            Icons.folder_open,
                            '프로젝트 그룹',
                            depth: 1,
                          ),
                          _buildTreeItem(Icons.list_alt, '프로젝트', depth: 2),
                          _buildTreeItem(
                            Icons.folder,
                            '업무 그룹',
                            depth: 3,
                          ), // 폴더 구조
                          _buildTreeItem(
                            Icons.check_box_outlined,
                            '업무 목록',
                            depth: 4,
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),

                  // 3. 하단 버튼 스택 (새 목록 위로 이동)
                  if (_isExpanded) ...[
                    _buildAddButton(Icons.add, '새 프로젝트 그룹'),
                    _buildAddButton(Icons.add, '새 프로젝트'),
                    _buildAddButton(Icons.add, '새 업무 그룹'),
                    _buildAddButton(Icons.add, '새 목록'),
                  ],
                  _buildMenuItem(
                    2,
                    Icons.settings_outlined,
                    Icons.settings,
                    '설정',
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // [크기 조절 핸들 및 마우스 커서]
          MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _sidebarWidth += details.delta.dx;
                  if (_sidebarWidth < 180) _sidebarWidth = 180;
                  if (_sidebarWidth > 500) _sidebarWidth = 500;
                });
              },
              child: Container(
                width: 4,
                color: Colors.transparent, // 투명하지만 드래그 영역 확보
                child: Center(
                  child: Container(width: 1, color: Colors.grey[300]),
                ),
              ),
            ),
          ),

          // [메인 콘텐츠 영역]
          Expanded(
            child: IndexedStack(
              index: _selectedIndex == 0 ? 0 : (_selectedIndex == 2 ? 2 : 1),
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }

  // --- 위젯 빌더 함수들 ---

  Widget _buildMenuHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(width: 3, height: 20, color: const Color(0xFF2564CF)),
            const SizedBox(width: 16),
            Icon(
              isSelected ? activeIcon : icon,
              size: 20,
              color: isSelected ? const Color(0xFF2564CF) : Colors.black54,
            ),
            if (_isExpanded) ...[
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? const Color(0xFF2564CF) : Colors.black87,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTreeItem(IconData icon, String label, {int depth = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0 + (depth * 16.0), top: 4, bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 12),
          if (_isExpanded)
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF2564CF)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF2564CF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
