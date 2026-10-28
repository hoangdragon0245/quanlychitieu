import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final AppDatabase _dbProvider;

  CategoryRepository({AppDatabase? dbProvider})
      : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _dbProvider.database;
    final results = await db.query('categories');
    return results.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    final db = await _dbProvider.database;
    final results = await db.query(
      'categories',
      where: 'type = ?',
      whereArgs: [type],
    );
    return results.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<void> insertCategory(CategoryModel category) async {
    final db = await _dbProvider.database;
    await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await _dbProvider.database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
