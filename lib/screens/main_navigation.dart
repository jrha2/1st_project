import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart'; // 경로 확인 필요

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  int _selectedFolderIndex = 0; // 이 줄을 새로 추가하세요!

  final List<Widget> _pages = [
    const TaskDetailView(), // 할일
    const Center(child: Text('루틴 페이지')),
    const Center(child: Text('캘린더 페이지')),
    const Center(child: Text('설정 페이지')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 4월 24일 버전의 상징, 하단 내비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: '할일'),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '캘린더',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),

      // 2. 바디 부분에서 왼쪽 그룹/폴더 바와 오른쪽 내용을 나눔
      body: Row(
        children: [
          // [좌측 메뉴 바]
          NavigationRail(
            selectedIndex: _selectedFolderIndex, // 새로 만들어야 할 변수입니다.
            onDestinationSelected: (int index) {
              setState(() {
                _selectedFolderIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.upcoming),
                label: Text('계획된 Task'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_alt),
                label: Text('전체 Task'),
              ),
            ],
          ),

          const VerticalDivider(thickness: 1, width: 1), // 구분선
          // [우측 메인 콘텐츠]
          Expanded(
            child: _pages[_selectedIndex], // 원래 나오던 페이지가 여기에 나옵니다.
          ),
        ],
      ),
    );
  }

  Widget _buildFolderIcon(IconData icon, String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.blue : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
