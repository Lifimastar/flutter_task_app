import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  // Inicializa la base de datos.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crea la tabla de tareas.
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE tasks (
      id $idType,
      title $textType,
      isDone $boolType
      )
      ''');
  }

  // --- Operaciones CRUD (Create, Read, Update, Delete) ---

  // Leer todas las tareas
  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  // Actualizar una tarea
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // TODO: Implementar createTask y deleteTask en los siguientes pasos.

  // Cerrar base de datos.
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
