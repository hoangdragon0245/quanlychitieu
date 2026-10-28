import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/icon_helper.dart';
import '../../category/models/category_model.dart';
import '../../category/providers/category_provider.dart';
import '../../wallet/models/wallet_model.dart';
import '../../wallet/providers/wallet_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/custom_numpad.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  String _transactionType = 'expense'; // 'expense', 'income', 'transfer'
  String _amountStr = '0';
  CategoryModel? _selectedCategory;
  WalletModel? _selectedWallet;
  WalletModel? _selectedToWallet;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onNumpadInput(String value) {
    setState(() {
      if (_amountStr == '0') {
        _amountStr = value;
      } else {
        if (_amountStr.length < 12) {
          _amountStr += value;
        }
      }
    });
  }

  void _onNumpadDelete() {
    setState(() {
      if (_amountStr.length <= 1) {
        _amountStr = '0';
      } else {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      }
    });
  }

  void _onNumpadClear() {
    setState(() {
      _amountStr = '0';
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountStr) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền lớn hơn 0')),
      );
      return;
    }

    if (_selectedWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ví/tài khoản')),
      );
      return;
    }

    if (_transactionType != 'transfer' && _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn danh mục')),
      );
      return;
    }

    if (_transactionType == 'transfer' && _selectedToWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ví nhận')),
      );
      return;
    }

    if (_transactionType == 'transfer' &&
        _selectedWallet!.id == _selectedToWallet!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ví nguồn và ví nhận phải khác nhau')),
      );
      return;
    }

    await ref.read(transactionProvider.notifier).addTransaction(
          amount: amount,
          type: _transactionType,
          categoryId: _selectedCategory?.id,
          walletId: _selectedWallet!.id,
          toWalletId: _selectedToWallet?.id,
          dateTime: _selectedDate,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

    HapticFeedback.mediumImpact();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(walletProvider);
    final categoriesAsync = _transactionType == 'expense'
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    final amountValue = double.tryParse(_amountStr) ?? 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Giao Dịch'),
        actions: [
          TextButton(
            onPressed: _saveTransaction,
            child: const Text(
              'Lưu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    // Type Selector Tabs
                    CupertinoSlidingSegmentedControl<String>(
                      groupValue: _transactionType,
                      children: const {
                        'expense': Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Chi tiêu',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        'income': Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Thu nhập',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        'transfer': Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Chuyển khoản',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      },
                      onValueChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _transactionType = val;
                            _selectedCategory = null;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Amount Display
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Số tiền',
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              CurrencyFormatter.format(amountValue),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: _transactionType == 'expense'
                                    ? AppColors.expense
                                    : _transactionType == 'income'
                                        ? AppColors.income
                                        : AppColors.transfer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Wallets Row
                    walletsAsync.when(
                      data: (wallets) {
                        if (wallets.isEmpty) return const SizedBox.shrink();
                        _selectedWallet ??= wallets.first;
                        if (_transactionType == 'transfer' &&
                            wallets.length > 1) {
                          _selectedToWallet ??= wallets[1];
                        }

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(CupertinoIcons.creditcard_fill,
                                      size: 18, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    _transactionType == 'transfer'
                                        ? 'Từ ví:'
                                        : 'Tài khoản / Ví:',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  DropdownButton<String>(
                                    value: _selectedWallet?.id,
                                    underline: const SizedBox(),
                                    items: wallets.map((w) {
                                      return DropdownMenuItem(
                                        value: w.id,
                                        child: Text(w.name),
                                      );
                                    }).toList(),
                                    onChanged: (id) {
                                      if (id != null) {
                                        setState(() {
                                          _selectedWallet = wallets
                                              .firstWhere((w) => w.id == id);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (_transactionType == 'transfer') ...[
                                const Divider(height: 16),
                                Row(
                                  children: [
                                    const Icon(
                                        CupertinoIcons
                                            .arrow_right_arrow_left_circle_fill,
                                        size: 18,
                                        color: AppColors.transfer),
                                    const SizedBox(width: 8),
                                    const Text('Đến ví:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    DropdownButton<String>(
                                      value: _selectedToWallet?.id,
                                      underline: const SizedBox(),
                                      items: wallets.map((w) {
                                        return DropdownMenuItem(
                                          value: w.id,
                                          child: Text(w.name),
                                        );
                                      }).toList(),
                                      onChanged: (id) {
                                        if (id != null) {
                                          setState(() {
                                            _selectedToWallet = wallets
                                                .firstWhere((w) => w.id == id);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(
                          child: CupertinoActivityIndicator()),
                      error: (err, _) => Text('Lỗi ví: $err'),
                    ),

                    const SizedBox(height: 16),

                    // Categories Grid (Only for Expense & Income)
                    if (_transactionType != 'transfer') ...[
                      const Text(
                        'Danh mục',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      categoriesAsync.when(
                        data: (categories) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              final isSelected =
                                  _selectedCategory?.id == cat.id;
                              final catColor =
                                  IconHelper.parseHexColor(cat.colorHex);

                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _selectedCategory = cat;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? catColor.withOpacity(0.18)
                                        : (isDark
                                            ? AppColors.cardDark
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? catColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            catColor.withOpacity(0.2),
                                        radius: 20,
                                        child: Icon(
                                          IconHelper.getCupertinoIcon(cat.icon),
                                          color: catColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        cat.name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                            child: CupertinoActivityIndicator()),
                        error: (err, _) => Text('Lỗi: $err'),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Date & Note Row
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickDate,
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.calendar,
                                    size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text('Ngày:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Text(
                                  DateFormatter.formatDate(_selectedDate),
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 20),
                          Row(
                            children: [
                              const Icon(CupertinoIcons.pencil_ellipsis_rectangle,
                                  size: 18,
                                  color: AppColors.textSecondaryLight),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _noteController,
                                  decoration: const InputDecoration(
                                    hintText: 'Ghi chú (không bắt buộc)',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Custom Numpad on Bottom
            CustomNumpad(
              onKeyPressed: _onNumpadInput,
              onDelete: _onNumpadDelete,
              onClear: _onNumpadClear,
            ),
          ],
        ),
      ),
    );
  }
}
