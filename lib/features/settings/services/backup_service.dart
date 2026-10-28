import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/database/app_database.dart';

class BackupService {
  final AppDatabase _dbProvider;

  BackupService({AppDatabase? dbProvider})
      : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<void> exportDataToShareSheet() async {
    final db = await _dbProvider.database;

    final wallets = await db.query('wallets');
    final categories = await db.query('categories');
    final transactions = await db.query('transactions');
    final budgets = await db.query('budgets');

    final backupPayload = {
      'app': 'QuanLyChiTieu_iOS',
      'version': '1.0.0',
      'exported_at': DateTime.now().toIso8601String(),
      'wallets': wallets,
      'categories': categories,
      'transactions': transactions,
      'budgets': budgets,
    };

    final jsonString = jsonEncode(backupPayload);

    final tempDir = await getTemporaryDirectory();
    final fileName =
        'QuanLyChiTieu_Backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(jsonString);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Sao lưu dữ liệu Quản Lý Chi Tiêu',
    );
  }
}
