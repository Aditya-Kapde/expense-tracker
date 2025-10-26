import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RemainingFundsChart extends StatefulWidget {
  final String timePeriod;

  const RemainingFundsChart({
    super.key,
    required this.timePeriod,
  });

  @override
  State<RemainingFundsChart> createState() => _RemainingFundsChartState();
}

class _RemainingFundsChartState extends State<RemainingFundsChart> {
  int touchedIndex = -1;

  // Mock financial data based on time period
  Map<String, double> _getFinancialData() {
    switch (widget.timePeriod.toLowerCase()) {
      case 'daily':
        return {
          'income': 500.0,
          'expenses': 150.0,
          'savings': 350.0,
        };
      case 'weekly':
        return {
          'income': 3500.0,
          'expenses': 1050.0,
          'savings': 2450.0,
        };
      case 'monthly':
        return {
          'income': 15000.0,
          'expenses': 4500.0,
          'savings': 10500.0,
        };
      case 'yearly':
        return {
          'income': 180000.0,
          'expenses': 54000.0,
          'savings': 126000.0,
        };
      default:
        return {
          'income': 15000.0,
          'expenses': 4500.0,
          'savings': 10500.0,
        };
    }
  }

  List<Map<String, dynamic>> _getFundsBreakdown() {
    final data = _getFinancialData();
    return [
      {
        'category': 'Savings',
        'amount': data['savings']!,
        'color': const Color(0xFF388E3C),
        'icon': 'savings',
      },
      {
        'category': 'Expenses',
        'amount': data['expenses']!,
        'color': const Color(0xFFC62828),
        'icon': 'trending_down',
      },
    ];
  }

  double _getSavingsRate() {
    final data = _getFinancialData();
    return (data['savings']! / data['income']!) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fundsData = _getFundsBreakdown();
    final financialData = _getFinancialData();
    final savingsRate = _getSavingsRate();
    final totalAmount = financialData['savings']! + financialData['expenses']!;

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
                'Remaining Funds',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: const Color(0xFF388E3C),
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
                        "Remaining Funds Pie Chart showing savings vs expenses breakdown",
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
                        sectionsSpace: 4,
                        centerSpaceRadius: 10.w,
                        sections: fundsData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          final isTouched = index == touchedIndex;
                          final fontSize = isTouched ? 16.sp : 14.sp;
                          final radius = isTouched ? 14.w : 12.w;
                          final percentage =
                              ((data['amount'] as double) / totalAmount * 100);

                          return PieChartSectionData(
                            color: data['color'] as Color,
                            value: data['amount'] as double,
                            title: '${percentage.toStringAsFixed(1)}%',
                            radius: radius,
                            titleStyle: theme.textTheme.labelMedium?.copyWith(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            badgeWidget: isTouched
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.shadowColor
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                          iconName: data['icon'] as String,
                                          color: data['color'] as Color,
                                          size: 20,
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          '\$${(data['amount'] as double).toStringAsFixed(0)}',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                            badgePositionPercentageOffset: 1.3,
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
                      // Financial breakdown
                      ...fundsData.map((data) {
                        final percentage =
                            ((data['amount'] as double) / totalAmount * 100);

                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: (data['color'] as Color)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (data['color'] as Color)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: data['icon'] as String,
                                      color: data['color'] as Color,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        data['category'] as String,
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: data['color'] as Color,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  '\$${(data['amount'] as double).toStringAsFixed(0)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: data['color'] as Color,
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(1)}% of total',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      // Savings rate indicator
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF388E3C).withValues(alpha: 0.1),
                              const Color(0xFF4CAF50).withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                const Color(0xFF388E3C).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'trending_up',
                                  color: const Color(0xFF388E3C),
                                  size: 18,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Savings Rate',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF388E3C),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              '${savingsRate.toStringAsFixed(1)}%',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF388E3C),
                              ),
                            ),
                            Text(
                              savingsRate >= 20
                                  ? 'Excellent!'
                                  : savingsRate >= 10
                                      ? 'Good'
                                      : 'Needs improvement',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
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
