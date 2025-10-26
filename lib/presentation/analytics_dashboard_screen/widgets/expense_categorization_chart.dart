import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExpenseCategorization extends StatefulWidget {
  final String timePeriod;

  const ExpenseCategorization({
    super.key,
    required this.timePeriod,
  });

  @override
  State<ExpenseCategorization> createState() => _ExpenseCategorizationState();
}

class _ExpenseCategorizationState extends State<ExpenseCategorization> {
  int touchedIndex = -1;

  // Mock expense data based on time period
  List<Map<String, dynamic>> _getExpenseData() {
    switch (widget.timePeriod.toLowerCase()) {
      case 'daily':
        return [
          {
            'category': 'Food & Dining',
            'amount': 45.0,
            'color': const Color(0xFFC62828)
          },
          {
            'category': 'Transportation',
            'amount': 25.0,
            'color': const Color(0xFFF57C00)
          },
          {
            'category': 'Shopping',
            'amount': 35.0,
            'color': const Color(0xFF1976D2)
          },
          {
            'category': 'Entertainment',
            'amount': 20.0,
            'color': const Color(0xFF7B1FA2)
          },
          {
            'category': 'Bills & Utilities',
            'amount': 15.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Healthcare',
            'amount': 10.0,
            'color': const Color(0xFFD32F2F)
          },
        ];
      case 'weekly':
        return [
          {
            'category': 'Food & Dining',
            'amount': 315.0,
            'color': const Color(0xFFC62828)
          },
          {
            'category': 'Transportation',
            'amount': 175.0,
            'color': const Color(0xFFF57C00)
          },
          {
            'category': 'Shopping',
            'amount': 245.0,
            'color': const Color(0xFF1976D2)
          },
          {
            'category': 'Entertainment',
            'amount': 140.0,
            'color': const Color(0xFF7B1FA2)
          },
          {
            'category': 'Bills & Utilities',
            'amount': 105.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Healthcare',
            'amount': 70.0,
            'color': const Color(0xFFD32F2F)
          },
        ];
      case 'monthly':
        return [
          {
            'category': 'Food & Dining',
            'amount': 1350.0,
            'color': const Color(0xFFC62828)
          },
          {
            'category': 'Transportation',
            'amount': 750.0,
            'color': const Color(0xFFF57C00)
          },
          {
            'category': 'Shopping',
            'amount': 1050.0,
            'color': const Color(0xFF1976D2)
          },
          {
            'category': 'Entertainment',
            'amount': 600.0,
            'color': const Color(0xFF7B1FA2)
          },
          {
            'category': 'Bills & Utilities',
            'amount': 450.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Healthcare',
            'amount': 300.0,
            'color': const Color(0xFFD32F2F)
          },
        ];
      case 'yearly':
        return [
          {
            'category': 'Food & Dining',
            'amount': 16200.0,
            'color': const Color(0xFFC62828)
          },
          {
            'category': 'Transportation',
            'amount': 9000.0,
            'color': const Color(0xFFF57C00)
          },
          {
            'category': 'Shopping',
            'amount': 12600.0,
            'color': const Color(0xFF1976D2)
          },
          {
            'category': 'Entertainment',
            'amount': 7200.0,
            'color': const Color(0xFF7B1FA2)
          },
          {
            'category': 'Bills & Utilities',
            'amount': 5400.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Healthcare',
            'amount': 3600.0,
            'color': const Color(0xFFD32F2F)
          },
        ];
      default:
        return [
          {
            'category': 'Food & Dining',
            'amount': 1350.0,
            'color': const Color(0xFFC62828)
          },
          {
            'category': 'Transportation',
            'amount': 750.0,
            'color': const Color(0xFFF57C00)
          },
          {
            'category': 'Shopping',
            'amount': 1050.0,
            'color': const Color(0xFF1976D2)
          },
          {
            'category': 'Entertainment',
            'amount': 600.0,
            'color': const Color(0xFF7B1FA2)
          },
          {
            'category': 'Bills & Utilities',
            'amount': 450.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Healthcare',
            'amount': 300.0,
            'color': const Color(0xFFD32F2F)
          },
        ];
    }
  }

  double _getTotalExpenses() {
    return _getExpenseData()
        .fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final expenseData = _getExpenseData();
    final totalExpenses = _getTotalExpenses();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expense Categories',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: 'trending_down',
                color: const Color(0xFFC62828),
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 30.h,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Semantics(
                    label:
                        "Expense Categories Pie Chart showing spending breakdown by category",
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 8.w,
                        sections: expenseData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          final isTouched = index == touchedIndex;
                          final fontSize = isTouched ? 14.sp : 12.sp;
                          final radius = isTouched ? 12.w : 10.w;
                          final percentage = ((data['amount'] as double) /
                              totalExpenses *
                              100);

                          return PieChartSectionData(
                            color: data['color'] as Color,
                            value: data['amount'] as double,
                            title: '${percentage.toStringAsFixed(1)}%',
                            radius: radius,
                            titleStyle: theme.textTheme.labelMedium?.copyWith(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            badgeWidget: isTouched
                                ? Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.shadowColor
                                              .withValues(alpha: 0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '\$${(data['amount'] as double).toStringAsFixed(0)}',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  )
                                : null,
                            badgePositionPercentageOffset: 1.2,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...expenseData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          final percentage = ((data['amount'] as double) /
                              totalExpenses *
                              100);

                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 3.w,
                                  height: 3.w,
                                  decoration: BoxDecoration(
                                    color: data['color'] as Color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['category'] as String,
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '\$${(data['amount'] as double).toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFC62828).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Expenses',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFFC62828),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '\$${totalExpenses.toStringAsFixed(0)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFFC62828),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
