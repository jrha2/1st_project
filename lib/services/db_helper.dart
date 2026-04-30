import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart'; // FullTaskModel이 정의된 경로를 정확히 임포트합니다.

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // 데이터베이스 테이블 생성 (FullTaskModel 구조에 맞춤)
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        isDone INTEGER,
        isImportant INTEGER,
        memo TEXT,
        dueDate TEXT,
        alarm TEXT,
        assignee TEXT
      )
    ''');
  }

  // 1. 작업 추가 (Create)
  Future<int> insertTask(FullTaskModel task) async {
    final db = await database;
    return await db.insert('tasks', {
      'title': task.title,
      'isDone': task.isDone ? 1 : 0,
      'isImportant': task.isImportant ? 1 : 0,
      'memo': task.memo,
      'dueDate': task.dueDate,
      'alarm': task.alarm,
      'assignee': task.assignee,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 2. 전체 작업 목록 불러오기 (Read)
  Future<List<FullTaskModel>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return FullTaskModel(
        title: maps[i]['title'],
        isDone: maps[i]['isDone'] == 1,
        isImportant: maps[i]['isImportant'] == 1,
        memo: maps[i]['memo'],
        dueDate: maps[i]['dueDate'],
        alarm: maps[i]['alarm'],
        assignee: maps[i]['assignee'],
        steps: [], // 세부 항목은 별도 테이블 관리가 권장되나 우선 빈 리스트로 초기화
      );
    });
  }

  // 3. 작업 업데이트 (Update)
  Future<int> updateTask(FullTaskModel task, int id) async {
    final db = await database;
    return await db.update(
      'tasks',
      {
        'title': task.title,
        'isDone': task.isDone ? 1 : 0,
        'isImportant': task.isImportant ? 1 : 0,
        'memo': task.memo,
        'dueDate': task.dueDate,
        'alarm': task.alarm,
        'assignee': task.assignee,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 4. 작업 삭제 (Delete)
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
