import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExpenseSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  final Map<String, dynamic> filters;

  const ExpenseSummaryWidget({
    super.key,
    required this.expenses,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalExpenses = _calculateTotalExpenses();
    final expenseCount = expenses.length;
    final averageExpense =
        expenseCount > 0 ? totalExpenses / expenseCount : 0.0;
    final topCategory = _getTopCategory();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                'Expense Summary',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$expenseCount transactions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Spent',
                  '\$${totalExpenses.toStringAsFixed(2)}',
                  'trending_down',
                  colorScheme.error,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Average',
                  '\$${averageExpense.toStringAsFixed(2)}',
                  'analytics',
                  colorScheme.primary,
                ),
              ),
            ],
          ),
          if (topCategory.isNotEmpty) ...[
            SizedBox(height: 2.h),
            _buildTopCategoryCard(context, topCategory),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 5.w,
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategoryCard(
      BuildContext context, Map<String, dynamic> topCategory) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getCategoryColor(topCategory['category'])
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getCategoryIcon(topCategory['category']),
                color: _getCategoryColor(topCategory['category']),
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Category',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  topCategory['category'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${topCategory['amount'].toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                '${topCategory['count']} transactions',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotalExpenses() {
    return expenses.fold(
        0.0, (sum, expense) => sum + (expense['amount'] as double));
  }

  Map<String, dynamic> _getTopCategory() {
    if (expenses.isEmpty) return {};

    final categoryTotals = <String, Map<String, dynamic>>{};

    for (final expense in expenses) {
      final category = expense['category'] as String;
      final amount = expense['amount'] as double;

      if (categoryTotals.containsKey(category)) {
        categoryTotals[category]!['amount'] += amount;
        categoryTotals[category]!['count'] += 1;
      } else {
        categoryTotals[category] = {
          'category': category,
          'amount': amount,
          'count': 1,
        };
      }
    }

    if (categoryTotals.isEmpty) return {};

    return categoryTotals.values.reduce(
        (a, b) => (a['amount'] as double) > (b['amount'] as double) ? a : b);
  }

  String _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return 'restaurant';
      case 'transport':
        return 'directions_car';
      case 'utilities':
        return 'electrical_services';
      case 'entertainment':
        return 'movie';
      case 'shopping':
        return 'shopping_bag';
      case 'healthcare':
        return 'local_hospital';
      case 'education':
        return 'school';
      case 'travel':
        return 'flight';
      case 'fitness':
        return 'fitness_center';
      case 'groceries':
        return 'local_grocery_store';
      default:
        return 'category';
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return const Color(0xFFFF6B6B);
      case 'transport':
        return const Color(0xFF4ECDC4);
      case 'utilities':
        return const Color(0xFFFFE66D);
      case 'entertainment':
        return const Color(0xFFFF8B94);
      case 'shopping':
        return const Color(0xFFA8E6CF);
      case 'healthcare':
        return const Color(0xFFFFAB91);
      case 'education':
        return const Color(0xFF81C784);
      case 'travel':
        return const Color(0xFF64B5F6);
      case 'fitness':
        return const Color(0xFFBA68C8);
      case 'groceries':
        return const Color(0xFF4DB6AC);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
