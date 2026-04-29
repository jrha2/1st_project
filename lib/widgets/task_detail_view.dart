import 'package:flutter/material.dart';
import 'widgets/task_detail_view.dart'; // 프로젝트 구조에 따라 경로 확인

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 1; // 기본 '할 일' 선택

  final List<Widget> _pages = [
    const TaskDetailView(showOnlyImportant: true), // 즐겨찾기
    const TaskDetailView(showOnlyImportant: false), // 할 일
    const Center(child: Text('설정')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) =>
                setState(() => _selectedIndex = index),
            backgroundColor: const Color(0xFFF3F2F1),
            indicatorColor: const Color(0xFF2564CF).withValues(alpha: 0.1),
            selectedIconTheme: const IconThemeData(color: Color(0xFF2564CF)),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text('즐겨찾기'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.check_circle_outline),
                selectedIcon: Icon(Icons.check_circle),
                label: Text('할 일'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('설정'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.black12),
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
        ],
      ),
    );
  }
}
