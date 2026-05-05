class TaskStep {
  String title;
  bool isDone;
  TaskStep({required this.title, this.isDone = false});

  // DB 저장을 위한 변환 함수
  Map<String, dynamic> toMap() => {'title': title, 'isDone': isDone ? 1 : 0};
  factory TaskStep.fromMap(Map<String, dynamic> map) => 
      TaskStep(title: map['title'], isDone: map['isDone'] == 1);
}

class TaskComment {
  final String author;
  final String content;
  final DateTime timestamp;

  TaskComment({required this.author, required this.content, required this.timestamp});
}

class TaskModel { // 이름을 TaskModel로 통일하여 다른 파일과의 충돌을 방지합니다.
  int? id;
  String title;
  String? description; // DB의 description 컬럼과 매칭
  int? parentId;
  int level;
  bool isDone;
  bool isImportant;
  List<TaskStep> steps;
  List<TaskComment> comments;
  String? dueDate;

  TaskModel({
    this.id,
    required this.title,
    this.description,
    this.parentId,
    this.level = 1,
    this.isDone = false,
    this.isImportant = false,
    this.steps = const [],
    this.comments = const [],
    this.dueDate,
  });

  // DB 저장용 Map 변환 (DbHelper에서 사용)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'parentId': parentId,
      'level': level,
      'isCompleted': isDone ? 1 : 0,
    };
  }

  // DB 데이터를 객체로 변환 (DbHelper에서 사용)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      parentId: map['parentId'],
      level: map['level'] ?? 1,
      isDone: map['isCompleted'] == 1,
    );
  }

  // 데이터 수정 시 복사본 생성을 위한 함수 (MainNavigation에서 사용)
  TaskModel copyWith({String? title, String? description}) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      parentId: parentId,
      level: level,
      isDone: isDone,
      isImportant: isImportant,
      steps: steps,
      comments: comments,
      dueDate: dueDate,
    );
  }
}