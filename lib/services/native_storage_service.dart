// native_storage_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import 'storage_service.dart';

class NativeStorageService implements StorageService {
  static final NativeStorageService _instance =
      NativeStorageService._internal();

  factory NativeStorageService() => _instance;

  NativeStorageService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'books_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE favorites(id TEXT PRIMARY KEY, title TEXT, author TEXT, imageUrl TEXT)',
        );
      },
    );
  }

  @override
  Future<void> saveBook(Book book) async {
    final db = await database;

    await db.insert(
      'favorites',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Book>> getAllBooks() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  @override
  Future<bool> isBookSaved(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty;
  }

  @override
  Future<void> deleteBook(String id) async {
    final db = await database;

    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
