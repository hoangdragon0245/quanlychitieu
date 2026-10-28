import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quanlychitieu/core/constants/app_colors.dart';
import 'package:quanlychitieu/core/utils/currency_formatter.dart';
import 'package:quanlychitieu/features/transaction/presentation/screens/add_transaction_screen.dart';
import 'package:quanlychitieu/features/transaction/providers/transaction_provider.dart';
import 'package:quanlychitieu/features/wallet/providers/wallet_provider.dart';
import '../widgets/transaction_item_tile.dart';
import '../widgets/wallet_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalance = ref.watch(totalBalanceProvider);
    final summary = ref.watch(currentMonthSummaryProvider);
    final walletsAsync = ref.watch(walletProvider);
    final transactionsAsync = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ Thu Chi Cá Nhân'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.plus_circle_fill,
                color: AppColors.primary, size: 28),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const AddTransactionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(walletProvider.notifier).loadWallets();
          await ref.read(transactionProvider.notifier).loadTransactions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Balance & Summary Card
              walletsAsync.when(
                data: (wallets) => WalletCard(
                  totalBalance: totalBalance,
                  monthlyIncome: summary['income'] ?? 0.0,
                  monthlyExpense: summary['expense'] ?? 0.0,
                  wallets: wallets,
                ),
                loading: () => const SizedBox(
                  height: 160,
                  child: Center(child: CupertinoActivityIndicator()),
                ),
                error: (err, _) => Text('Lỗi: $err'),
              ),

              const SizedBox(height: 24),

              // Wallets horizontal list
              const Text(
                'Tài khoản & Ví',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              walletsAsync.when(
                data: (wallets) {
                  return SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: wallets.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final w = wallets[index];
                        final isDark =
                            Theme.of(context).brightness == Brightness.dark;
                        return Container(
                          width: 140,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                w.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondaryLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.format(w.currentBalance),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giao dịch gần đây',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Vuốt để xóa',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Transactions List
              transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.tray,
                            size: 48,
                            color: AppColors.textSecondaryLight.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Chưa có giao dịch nào.\nBấm dấu (+) để thêm khoản thu/chi đầu tiên!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return TransactionItemTile(
                        transaction: t,
                        onDelete: () {
                          ref
                              .read(transactionProvider.notifier)
                              .deleteTransaction(t);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CupertinoActivityIndicator(),
                  ),
                ),
                error: (err, _) => Text('Lỗi tải giao dịch: $err'),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
