import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../transaction/models/transaction_model.dart';

class TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionItemTile({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpense = transaction.type == 'expense';
    final isIncome = transaction.type == 'income';
    final isTransfer = transaction.type == 'transfer';

    Color amountColor;
    String prefix;

    if (isExpense) {
      amountColor = AppColors.expense;
      prefix = '-';
    } else if (isIncome) {
      amountColor = AppColors.income;
      prefix = '+';
    } else {
      amountColor = AppColors.transfer;
      prefix = '';
    }

    final categoryColor = transaction.categoryColor != null
        ? IconHelper.parseHexColor(transaction.categoryColor!)
        : (isTransfer ? AppColors.transfer : AppColors.primary);

    final title = isTransfer
        ? '${transaction.walletName ?? "Ví"} ➔ ${transaction.toWalletName ?? "Ví"}'
        : (transaction.categoryName ?? 'Chưa phân loại');

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(CupertinoIcons.trash, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showCupertinoDialog<bool>(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa giao dịch này?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Hủy'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Xóa'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: categoryColor.withOpacity(0.18),
              child: Icon(
                isTransfer
                    ? CupertinoIcons.arrow_right_arrow_left
                    : IconHelper.getCupertinoIcon(
                        transaction.categoryIcon ?? ''),
                color: categoryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        DateFormatter.relativeDate(transaction.dateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      if (transaction.note != null &&
                          transaction.note!.isNotEmpty) ...[
                        const Text(' • ',
                            style:
                                TextStyle(color: AppColors.textSecondaryLight)),
                        Expanded(
                          child: Text(
                            transaction.note!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$prefix${CurrencyFormatter.format(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
