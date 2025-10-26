import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SummaryMetricsCards extends StatelessWidget {
  final String timePeriod;

  const SummaryMetricsCards({
    super.key,
    required this.timePeriod,
  });

  // Mock metrics data based on time period
  Map<String, dynamic> _getMetricsData() {
    switch (timePeriod.toLowerCase()) {
      case 'daily':
        return {
          'highestExpenseCategory': {
            'name': 'Food & Dining',
            'amount': 45.0,
            'change': 12.5
          },
          'averageDailySpending': {'amount': 150.0, 'change': -8.3},
          'savingsRate': {'percentage': 70.0, 'change': 5.2},
        };
      case 'weekly':
        return {
          'highestExpenseCategory': {
            'name': 'Food & Dining',
            'amount': 315.0,
            'change': 18.7
          },
          'averageDailySpending': {'amount': 150.0, 'change': -5.1},
          'savingsRate': {'percentage': 70.0, 'change': 3.8},
        };
      case 'monthly':
        return {
          'highestExpenseCategory': {
            'name': 'Food & Dining',
            'amount': 1350.0,
            'change': 22.3
          },
          'averageDailySpending': {'amount': 145.2, 'change': -12.7},
          'savingsRate': {'percentage': 70.0, 'change': 8.9},
        };
      case 'yearly':
        return {
          'highestExpenseCategory': {
            'name': 'Food & Dining',
            'amount': 16200.0,
            'change': 15.4
          },
          'averageDailySpending': {'amount': 147.9, 'change': -6.2},
          'savingsRate': {'percentage': 70.0, 'change': 12.1},
        };
      default:
        return {
          'highestExpenseCategory': {
            'name': 'Food & Dining',
            'amount': 1350.0,
            'change': 22.3
          },
          'averageDailySpending': {'amount': 145.2, 'change': -12.7},
          'savingsRate': {'percentage': 70.0, 'change': 8.9},
        };
    }
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required double changePercentage,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPositiveChange = changePercentage >= 0;
    final changeColor =
        isPositiveChange ? const Color(0xFF388E3C) : const Color(0xFFC62828);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
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
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: icon.codePoint.toString(),
                  color: iconColor,
                  size: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName:
                          isPositiveChange ? 'trending_up' : 'trending_down',
                      color: changeColor,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${isPositiveChange ? '+' : ''}${changePercentage.toStringAsFixed(1)}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metricsData = _getMetricsData();
    final highestExpense =
        metricsData['highestExpenseCategory'] as Map<String, dynamic>;
    final avgSpending =
        metricsData['averageDailySpending'] as Map<String, dynamic>;
    final savingsRate = metricsData['savingsRate'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Key Metrics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        SizedBox(height: 2.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              // Highest Expense Category Card
              SizedBox(
                width: 70.w,
                child: _buildMetricCard(
                  context: context,
                  title: 'Highest Expense Category',
                  value:
                      '\$${(highestExpense['amount'] as double).toStringAsFixed(0)}',
                  subtitle: '${highestExpense['name']} this $timePeriod',
                  changePercentage: highestExpense['change'] as double,
                  icon: Icons.restaurant,
                  iconColor: const Color(0xFFC62828),
                  accentColor: const Color(0xFFC62828),
                ),
              ),
              SizedBox(width: 4.w),

              // Average Daily Spending Card
              SizedBox(
                width: 70.w,
                child: _buildMetricCard(
                  context: context,
                  title: 'Average Daily Spending',
                  value:
                      '\$${(avgSpending['amount'] as double).toStringAsFixed(1)}',
                  subtitle: 'Per day this $timePeriod',
                  changePercentage: avgSpending['change'] as double,
                  icon: Icons.calculate,
                  iconColor: const Color(0xFF1976D2),
                  accentColor: const Color(0xFF1976D2),
                ),
              ),
              SizedBox(width: 4.w),

              // Savings Rate Card
              SizedBox(
                width: 70.w,
                child: _buildMetricCard(
                  context: context,
                  title: 'Savings Rate',
                  value:
                      '${(savingsRate['percentage'] as double).toStringAsFixed(1)}%',
                  subtitle: 'Of total income saved',
                  changePercentage: savingsRate['change'] as double,
                  icon: Icons.savings,
                  iconColor: const Color(0xFF388E3C),
                  accentColor: const Color(0xFF388E3C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
