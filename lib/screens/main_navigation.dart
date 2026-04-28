import 'package:flutter/material.dart';
import '../widgets/task_detail_view.dart'; // 경로 확인 필요

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

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
            icon: Icon(Icons.sync),
            label: '루틴',
          ), // Sync 소문자로 수정
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '캘린더',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
        ],
      ),
      // 2. 바디 부분에서 왼쪽 그룹/폴더 바와 오른쪽 내용을 나눔
      body: Row(
        children: [
          // 할일 탭(_selectedIndex == 0)일 때만 왼쪽 폴더 바 표시
          if (_selectedIndex == 0)
            Container(
              width: 70, // 4월 24일 버전 특유의 슬림한 폭
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  right: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildFolderIcon(Icons.grid_view, "전체", true),
                  _buildFolderIcon(Icons.work_outline, "업무", false),
                  _buildFolderIcon(Icons.person_outline, "개인", false),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      /* 그룹 추가 기능 나중에 구현 */
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

          // 실제 페이지 내용
          Expanded(child: _pages[_selectedIndex]),
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
