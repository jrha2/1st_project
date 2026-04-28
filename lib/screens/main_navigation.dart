import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('대시보드')),
    const TaskDetailView(), // 에러가 나던 위젯 호출부를 깔끔하게 정리했습니다.
    const Center(child: Text('설정')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        // Row를 사용하여 가로로 나눕니다.
        children: [
          // 왼쪽: 그룹 선택 바 (4월 24일 버전의 감성)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.grid_view),
                label: Text('전체'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work_outline),
                label: Text('업무'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                label: Text('개인'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // 오른쪽: 실제 할 일 내용
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
