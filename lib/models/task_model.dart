class TaskModel {
  final int? id; // DB의 고유 번호 (자동 생성)
  final String title; // 할 일 제목
  final String memo; // 상세 메모
  final int isCompleted; // 완료 여부 (0: 미완료, 1: 완료)

  TaskModel({
    this.id,
    required this.title,
    this.memo = '',
    this.isCompleted = 0,
  });

  // 1. 앱의 데이터를 DB에 저장하기 위해 Map 형태로 바꾸는 함수
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'memo': memo, 'isCompleted': isCompleted};
  }

  // 2. DB에서 가져온 Map 데이터를 다시 앱에서 쓰기 좋게 객체로 바꾸는 함수
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      memo: map['memo'],
      isCompleted: map['isCompleted'],
    );
  }
}
