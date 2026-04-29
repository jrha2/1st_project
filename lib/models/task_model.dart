class TaskModel {
  int? id; // DB 저장 시 자동으로 붙을 번호
  String title; // 할 일 제목
  bool isDone; // 완료 여부
  String? memo; // 메모
  DateTime? dueDate; // 마감 기한

  TaskModel({
    this.id,
    required this.title,
    this.isDone = false,
    this.memo,
    this.dueDate,
  });

  // DB에 저장하기 위해 데이터를 Map 형태로 변환하는 함수
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0, // SQLite는 bool 대신 0, 1을 씁니다
      'memo': memo,
      'dueDate': dueDate?.toIso8601String(),
    };
  }
}

class TaskStep {
  String title;
  bool isDone;
  TaskStep({required this.title, this.isDone = false});
}

class FullTaskModel {
  String title;
  bool isDone;
  bool isImportant; // 추가: 중요 여부
  List<TaskStep> steps;
  String memo;
  String? dueDate;
  String? alarm;
  String? assignee;

  FullTaskModel({
    required this.title,
    this.isDone = false,
    this.isImportant = false, // 기본값은 false
    this.steps = const [],
    this.memo = '',
    this.dueDate,
    this.alarm,
    this.assignee,
  });
}
