import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class IncomeDistributionChart extends StatefulWidget {
  final String timePeriod;

  const IncomeDistributionChart({
    super.key,
    required this.timePeriod,
  });

  @override
  State<IncomeDistributionChart> createState() =>
      _IncomeDistributionChartState();
}

class _IncomeDistributionChartState extends State<IncomeDistributionChart> {
  int touchedIndex = -1;

  // Mock income data based on time period
  List<Map<String, dynamic>> _getIncomeData() {
    switch (widget.timePeriod.toLowerCase()) {
      case 'daily':
        return [
          {
            'category': 'Salary',
            'amount': 250.0,
            'color': const Color(0xFF1B5E20)
          },
          {
            'category': 'Freelance',
            'amount': 150.0,
            'color': const Color(0xFF2E7D32)
          },
          {
            'category': 'Investment',
            'amount': 80.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Other',
            'amount': 20.0,
            'color': const Color(0xFF4CAF50)
          },
        ];
      case 'weekly':
        return [
          {
            'category': 'Salary',
            'amount': 1750.0,
            'color': const Color(0xFF1B5E20)
          },
          {
            'category': 'Freelance',
            'amount': 1050.0,
            'color': const Color(0xFF2E7D32)
          },
          {
            'category': 'Investment',
            'amount': 560.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Other',
            'amount': 140.0,
            'color': const Color(0xFF4CAF50)
          },
        ];
      case 'monthly':
        return [
          {
            'category': 'Salary',
            'amount': 7500.0,
            'color': const Color(0xFF1B5E20)
          },
          {
            'category': 'Freelance',
            'amount': 4500.0,
            'color': const Color(0xFF2E7D32)
          },
          {
            'category': 'Investment',
            'amount': 2400.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Other',
            'amount': 600.0,
            'color': const Color(0xFF4CAF50)
          },
        ];
      case 'yearly':
        return [
          {
            'category': 'Salary',
            'amount': 90000.0,
            'color': const Color(0xFF1B5E20)
          },
          {
            'category': 'Freelance',
            'amount': 54000.0,
            'color': const Color(0xFF2E7D32)
          },
          {
            'category': 'Investment',
            'amount': 28800.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Other',
            'amount': 7200.0,
            'color': const Color(0xFF4CAF50)
          },
        ];
      default:
        return [
          {
            'category': 'Salary',
            'amount': 7500.0,
            'color': const Color(0xFF1B5E20)
          },
          {
            'category': 'Freelance',
            'amount': 4500.0,
            'color': const Color(0xFF2E7D32)
          },
          {
            'category': 'Investment',
            'amount': 2400.0,
            'color': const Color(0xFF388E3C)
          },
          {
            'category': 'Other',
            'amount': 600.0,
            'color': const Color(0xFF4CAF50)
          },
        ];
    }
  }

  double _getTotalIncome() {
    return _getIncomeData()
        .fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final incomeData = _getIncomeData();
    final totalIncome = _getTotalIncome();

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
                'Income Distribution',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: 'trending_up',
                color: colorScheme.primary,
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
                        "Income Distribution Pie Chart showing breakdown by category",
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
                        sections: incomeData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          final isTouched = index == touchedIndex;
                          final fontSize = isTouched ? 14.sp : 12.sp;
                          final radius = isTouched ? 12.w : 10.w;
                          final percentage =
                              ((data['amount'] as double) / totalIncome * 100);

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...incomeData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        final percentage =
                            ((data['amount'] as double) / totalIncome * 100);

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['category'] as String,
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '\$${(data['amount'] as double).toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
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
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Income',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${totalIncome.toStringAsFixed(0)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
