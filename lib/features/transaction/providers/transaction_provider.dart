import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../wallet/providers/wallet_provider.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

class TransactionNotifier
    extends StateNotifier<AsyncValue<List<TransactionModel>>> {
  final TransactionRepository _repository;
  final Ref _ref;

  TransactionNotifier(this._repository, this._ref)
      : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final list = await _repository.getAllTransactions(limit: 200);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction({
    required double amount,
    required String type,
    String? categoryId,
    required String walletId,
    String? toWalletId,
    required DateTime dateTime,
    String? note,
    String? imagePath,
  }) async {
    final transaction = TransactionModel(
      id: const Uuid().v4(),
      amount: amount,
      type: type,
      categoryId: categoryId,
      walletId: walletId,
      toWalletId: toWalletId,
      dateTime: dateTime,
      note: note,
      imagePath: imagePath,
      createdAt: DateTime.now(),
    );

    await _repository.addTransaction(transaction);
    await loadTransactions();
    // Refresh wallets to update balances across the app
    await _ref.read(walletProvider.notifier).loadWallets();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _repository.deleteTransaction(transaction);
    await loadTransactions();
    await _ref.read(walletProvider.notifier).loadWallets();
  }
}

final transactionProvider = StateNotifierProvider<TransactionNotifier,
    AsyncValue<List<TransactionModel>>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repo, ref);
});

// Thống kê thu chi tháng hiện tại
final currentMonthSummaryProvider = Provider<{
  'income': double,
  'expense': double,
  'net': double,
}>((ref) {
  final transactionsState = ref.watch(transactionProvider);
  final now = DateTime.now();

  return transactionsState.when(
    data: (transactions) {
      double totalIncome = 0.0;
      double totalExpense = 0.0;

      for (final t in transactions) {
        if (t.dateTime.year == now.year && t.dateTime.month == now.month) {
          if (t.type == 'income') {
            totalIncome += t.amount;
          } else if (t.type == 'expense') {
            totalExpense += t.amount;
          }
        }
      }

      return {
        'income': totalIncome,
        'expense': totalExpense,
        'net': totalIncome - totalExpense,
      };
    },
    loading: () => {'income': 0.0, 'expense': 0.0, 'net': 0.0},
    error: (_, __) => {'income': 0.0, 'expense': 0.0, 'net': 0.0},
  );
});
