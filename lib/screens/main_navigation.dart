import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart'; // 할일 목록 화면

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // 하단 메뉴 번호 (할일, 캘린더, 설정)
  int _selectedFolderIndex = 1; // 좌측 폴더 번호 (0: 계획된, 1: 전체)

  // 하단 메뉴 클릭 시 화면 전환을 위한 리스트
  final List<Widget> _pages = [
    const TaskDetailView(), // 할일 페이지
    const Center(child: Text('캘린더 페이지')),
    const Center(child: Text('설정 페이지')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 하단 네비게이션 바 (루틴 삭제, 설정 추가)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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

      // 2. 메인 바디 (좌측 메뉴 + 우측 콘텐츠)
      body: Row(
        children: [
          // 좌측 슬림 메뉴 (계획된 Task, 전체 Task)
          NavigationRail(
            selectedIndex: _selectedFolderIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedFolderIndex = index;
              });
              // 여기서 나중에 필터링 로직(DB 쿼리)이 연결됩니다.
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.upcoming_outlined),
                selectedIcon: Icon(Icons.upcoming),
                label: Text('계획된 Task'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt),
                label: Text('전체 Task'),
              ),
            ],
          ),

          // 가로 구분선
          const VerticalDivider(thickness: 1, width: 1),

          // 우측 화면 (선택된 하단 메뉴에 따라 변함)
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
