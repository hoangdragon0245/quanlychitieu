import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/wallet_model.dart';
import '../repositories/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository();
});

class WalletNotifier extends StateNotifier<AsyncValue<List<WalletModel>>> {
  final WalletRepository _repository;

  WalletNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadWallets();
  }

  Future<void> loadWallets() async {
    try {
      final wallets = await _repository.getAllWallets();
      state = AsyncValue.data(wallets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addWallet({
    required String name,
    required String type,
    required double initialBalance,
    required String icon,
    required String colorHex,
  }) async {
    final newWallet = WalletModel(
      id: const Uuid().v4(),
      name: name,
      type: type,
      initialBalance: initialBalance,
      currentBalance: initialBalance,
      icon: icon,
      colorHex: colorHex,
      createdAt: DateTime.now(),
    );

    await _repository.insertWallet(newWallet);
    await loadWallets();
  }

  Future<void> deleteWallet(String id) async {
    await _repository.deleteWallet(id);
    await loadWallets();
  }
}

final walletProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<List<WalletModel>>>((ref) {
  final repo = ref.watch(walletRepositoryProvider);
  return WalletNotifier(repo);
});

// Provider tính tổng số dư tất cả các ví
final totalBalanceProvider = Provider<double>((ref) {
  final walletsState = ref.watch(walletProvider);
  return walletsState.when(
    data: (wallets) =>
        wallets.fold(0.0, (sum, wallet) => sum + wallet.currentBalance),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});
