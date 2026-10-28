import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/icon_helper.dart';
import '../../transaction/models/transaction_model.dart';
import '../../transaction/providers/transaction_provider.dart';

class CategoryExpenseSummary {
  final String categoryName;
  final String iconCode;
  final String colorHex;
  final double totalAmount;
  final double percentage;

  CategoryExpenseSummary({
    required this.categoryName,
    required this.iconCode,
    required this.colorHex,
    required this.totalAmount,
    required this.percentage,
  });
}

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _selectedFilter = 0; // 0: Tháng này, 1: Tháng trước, 2: Năm nay
  int _touchedIndex = -1;

  List<TransactionModel> _filterTransactions(List<TransactionModel> all) {
    final now = DateTime.now();

    if (_selectedFilter == 0) {
      // Tháng này
      return all.where((t) {
        return t.dateTime.year == now.year && t.dateTime.month == now.month;
      }).toList();
    } else if (_selectedFilter == 1) {
      // Tháng trước
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      final prevYear = now.month == 1 ? now.year - 1 : now.year;
      return all.where((t) {
        return t.dateTime.year == prevYear && t.dateTime.month == prevMonth;
      }).toList();
    } else {
      // Năm nay
      return all.where((t) {
        return t.dateTime.year == now.year;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê Chi Tiêu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Filter segmented control
            CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedFilter,
              children: const {
                0: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Tháng này',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Tháng trước',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                2: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Năm nay',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              },
              onValueChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedFilter = val;
                    _touchedIndex = -1;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            transactionsAsync.when(
              data: (allTransactions) {
                final filtered = _filterTransactions(allTransactions);
                final expenses =
                    filtered.where((t) => t.type == 'expense').toList();
                final totalExpense =
                    expenses.fold(0.0, (sum, t) => sum + t.amount);

                if (expenses.isEmpty) {
                  return Container(
                    height: 280,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.chart_pie,
                            size: 64, color: AppColors.textSecondaryLight),
                        SizedBox(height: 12),
                        Text(
                          'Không có dữ liệu chi tiêu trong kỳ này.',
                          style: TextStyle(color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  );
                }

                // Group by Category
                final Map<String, List<TransactionModel>> grouped = {};
                for (final e in expenses) {
                  final catKey = e.categoryName ?? 'Khác';
                  grouped.putIfAbsent(catKey, () => []).add(e);
                }

                final List<CategoryExpenseSummary> summaries = [];
                grouped.forEach((catName, list) {
                  final sum = list.fold(0.0, (s, t) => s + t.amount);
                  final first = list.first;
                  summaries.add(
                    CategoryExpenseSummary(
                      categoryName: catName,
                      iconCode: first.categoryIcon ?? '',
                      colorHex: first.categoryColor ?? '#007AFF',
                      totalAmount: sum,
                      percentage:
                          totalExpense > 0 ? (sum / totalExpense) * 100 : 0.0,
                    ),
                  );
                });

                // Sort descending
                summaries
                    .sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

                return Column(
                  children: [
                    // Total Expense Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng đã chi:',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(totalExpense),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.expense,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pie Chart
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 46,
                          sections: summaries.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            final isTouched = idx == _touchedIndex;
                            final fontSize = isTouched ? 14.0 : 11.0;
                            final radius = isTouched ? 58.0 : 50.0;
                            final color =
                                IconHelper.parseHexColor(item.colorHex);

                            return PieChartSectionData(
                              color: color,
                              value: item.totalAmount,
                              title: '${item.percentage.toStringAsFixed(0)}%',
                              radius: radius,
                              titleStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Ranked Category List
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chi tiết theo danh mục',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: summaries.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 20),
                            itemBuilder: (context, index) {
                              final item = summaries[index];
                              final color =
                                  IconHelper.parseHexColor(item.colorHex);

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            color.withOpacity(0.18),
                                        radius: 16,
                                        child: Icon(
                                          IconHelper.getCupertinoIcon(
                                              item.iconCode),
                                          color: color,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item.categoryName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        CurrencyFormatter.format(
                                            item.totalAmount),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: item.percentage / 100,
                                      backgroundColor: isDark
                                          ? Colors.white10
                                          : Colors.black12,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(color),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CupertinoActivityIndicator(),
                ),
              ),
              error: (err, _) => Text('Lỗi: $err'),
            ),
          ],
        ),
      ),
    );
  }
}
