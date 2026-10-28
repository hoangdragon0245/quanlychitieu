import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../models/wallet_model.dart';

class WalletRepository {
  final AppDatabase _dbProvider;

  WalletRepository({AppDatabase? dbProvider})
      : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<List<WalletModel>> getAllWallets() async {
    final db = await _dbProvider.database;
    final results = await db.query(
      'wallets',
      orderBy: 'created_at ASC',
    );
    return results.map((e) => WalletModel.fromMap(e)).toList();
  }

  Future<WalletModel?> getWalletById(String id) async {
    final db = await _dbProvider.database;
    final results = await db.query(
      'wallets',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return WalletModel.fromMap(results.first);
    }
    return null;
  }

  Future<void> insertWallet(WalletModel wallet) async {
    final db = await _dbProvider.database;
    await db.insert(
      'wallets',
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateWallet(WalletModel wallet) async {
    final db = await _dbProvider.database;
    await db.update(
      'wallets',
      wallet.toMap(),
      where: 'id = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<void> deleteWallet(String id) async {
    final db = await _dbProvider.database;
    await db.delete(
      'wallets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
