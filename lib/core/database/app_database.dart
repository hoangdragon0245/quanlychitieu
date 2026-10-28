import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../constants/default_categories.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quanlychitieu.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Wallets table
    await db.execute('''
      CREATE TABLE wallets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        initial_balance REAL NOT NULL,
        current_balance REAL NOT NULL,
        icon TEXT NOT NULL,
        color_hex TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // 2. Categories table
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon TEXT NOT NULL,
        color_hex TEXT NOT NULL,
        is_default INTEGER NOT NULL
      )
    ''');

    // 3. Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category_id TEXT,
        wallet_id TEXT NOT NULL,
        to_wallet_id TEXT,
        date_time TEXT NOT NULL,
        note TEXT,
        image_path TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (wallet_id) REFERENCES wallets (id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL
      )
    ''');

    // 4. Budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        amount_limit REAL NOT NULL,
        month_year TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Seed Initial Data
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    const uuid = Uuid();
    final now = DateTime.now().toIso8601String();

    // Default Wallets
    await db.insert('wallets', {
      'id': 'wallet_cash',
      'name': 'Tiền mặt',
      'type': 'cash',
      'initial_balance': 0.0,
      'current_balance': 0.0,
      'icon': 'money_dollar_circle_fill',
      'color_hex': '#34C759',
      'created_at': now,
    });

    await db.insert('wallets', {
      'id': 'wallet_bank',
      'name': 'Tài khoản Ngân hàng',
      'type': 'bank',
      'initial_balance': 0.0,
      'current_balance': 0.0,
      'icon': 'creditcard_fill',
      'color_hex': '#007AFF',
      'created_at': now,
    });

    // Default Expense Categories
    for (final cat in DefaultCategories.expenses) {
      await db.insert('categories', {
        'id': cat.id,
        'name': cat.name,
        'type': cat.type,
        'icon': cat.iconCode,
        'color_hex': cat.colorHex,
        'is_default': 1,
      });
    }

    // Default Income Categories
    for (final cat in DefaultCategories.incomes) {
      await db.insert('categories', {
        'id': cat.id,
        'name': cat.name,
        'type': cat.type,
        'icon': cat.iconCode,
        'color_hex': cat.colorHex,
        'is_default': 1,
      });
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
