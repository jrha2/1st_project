import 'package:flutter/material.dart';
import 'widgets/task_detail_view.dart'; // TaskDetailView 경로가 프로젝트 구조와 맞는지 확인하세요.

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // 현재 선택된 메뉴 인덱스 (기본값: 1번 '할 일')
  int _selectedIndex = 1;

  // 메뉴 클릭 시 보여줄 화면 리스트
  // TaskDetailView에 showOnlyImportant 인자를 전달하여 필터링 기능을 수행합니다.
  final List<Widget> _pages = [
    const TaskDetailView(showOnlyImportant: true), // 0번: 즐겨찾기 메뉴 선택 시
    const TaskDetailView(showOnlyImportant: false), // 1번: 할 일 메뉴 선택 시
    const Center(child: Text('설정 페이지 (준비 중)')), // 2번: 설정 등 기타 메뉴
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. 왼쪽 사이드 네비게이션 바 (NavigationRail)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            // Microsoft To Do 스타일의 배경색과 아이콘 색상 설정
            backgroundColor: const Color(0xFFF3F2F1),
            indicatorColor: const Color(0xFF2564CF).withValues(alpha: 0.1),
            selectedIconTheme: const IconThemeData(color: Color(0xFF2564CF)),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              // [추가된 메뉴] 즐겨찾기
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text('즐겨찾기'),
              ),
              // [기본 메뉴] 할 일
              NavigationRailDestination(
                icon: Icon(Icons.check_circle_outline),
                selectedIcon: Icon(Icons.check_circle),
                label: Text('할 일'),
              ),
              // [확장용] 설정
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('설정'),
              ),
            ],
          ),

          // 수직 구분선
          const VerticalDivider(thickness: 1, width: 1, color: Colors.black12),

          // 2. 오른쪽 메인 콘텐츠 영역
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
        ],
      ),
    );
  }
}
