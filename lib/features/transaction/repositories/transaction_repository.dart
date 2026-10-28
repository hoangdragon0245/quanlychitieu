import '../../../core/database/app_database.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final AppDatabase _dbProvider;

  TransactionRepository({AppDatabase? dbProvider})
      : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<List<TransactionModel>> getAllTransactions({int limit = 100}) async {
    final db = await _dbProvider.database;
    final results = await db.rawQuery('''
      SELECT 
        t.*, 
        c.name AS category_name, 
        c.icon AS category_icon, 
        c.color_hex AS category_color,
        w1.name AS wallet_name,
        w2.name AS to_wallet_name
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      LEFT JOIN wallets w1 ON t.wallet_id = w1.id
      LEFT JOIN wallets w2 ON t.to_wallet_id = w2.id
      ORDER BY t.date_time DESC, t.created_at DESC
      LIMIT ?
    ''', [limit]);

    return results.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime start, DateTime end) async {
    final db = await _dbProvider.database;
    final results = await db.rawQuery('''
      SELECT 
        t.*, 
        c.name AS category_name, 
        c.icon AS category_icon, 
        c.color_hex AS category_color,
        w1.name AS wallet_name,
        w2.name AS to_wallet_name
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      LEFT JOIN wallets w1 ON t.wallet_id = w1.id
      LEFT JOIN wallets w2 ON t.to_wallet_id = w2.id
      WHERE t.date_time >= ? AND t.date_time <= ?
      ORDER BY t.date_time DESC
    ''', [start.toIso8601String(), end.toIso8601String()]);

    return results.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final db = await _dbProvider.database;

    await db.transaction((txn) async {
      // 1. Insert Transaction
      await txn.insert('transactions', transaction.toMap());

      // 2. Adjust Wallets
      if (transaction.type == 'expense') {
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance - ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.walletId]);
      } else if (transaction.type == 'income') {
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance + ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.walletId]);
      } else if (transaction.type == 'transfer' && transaction.toWalletId != null) {
        // Trừ ví gửi
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance - ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.walletId]);
        // Cộng ví nhận
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance + ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.toWalletId]);
      }
    });
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    final db = await _dbProvider.database;

    await db.transaction((txn) async {
      // 1. Revert wallet changes
      if (transaction.type == 'expense') {
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance + ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.walletId]);
      } else if (transaction.type == 'income') {
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance - ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.walletId]);
      } else if (transaction.type == 'transfer' && transaction.toWalletId != null) {
        // Hoàn lại ví gửi
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance + ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.walletId]);
        // Trừ lại ví nhận
        await txn.rawUpdate('''
          UPDATE wallets 
          SET current_balance = current_balance - ? 
          WHERE id = ?
        ''', [transaction.amount, transaction.toWalletId]);
      }

      // 2. Delete the transaction record
      await txn.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    });
  }
}
