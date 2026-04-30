// 1. 답글(댓글)을 위한 클래스 정의
class TaskComment {
  final String author;
  final String content;
  final DateTime timestamp;

  TaskComment({
    required this.author,
    required this.content,
    required this.timestamp,
  });
}

// 2. 세부 항목 클래스
class TaskStep {
  String title;
  bool isDone;
  TaskStep({required this.title, this.isDone = false});
}

// 3. 전체 태스크 모델 (comments 필드 추가)
class FullTaskModel {
  int? id;
  String title;
  bool isDone;
  bool isImportant;
  List<TaskStep> steps;
  String memo;
  List<TaskComment> comments; // 이 부분이 누락되어 에러가 발생했습니다.
  String? dueDate;
  String? alarm;
  String? assignee;

  FullTaskModel({
    this.id,
    required this.title,
    this.isDone = false,
    this.isImportant = false,
    this.steps = const [],
    this.memo = '',
    this.comments = const [], // 초기값 빈 리스트 설정
    this.dueDate,
    this.alarm,
    this.assignee,
  });
}
