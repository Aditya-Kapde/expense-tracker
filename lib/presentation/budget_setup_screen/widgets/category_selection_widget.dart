import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategorySelectionWidget extends StatelessWidget {
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategoriesChanged;
  final bool isOverallBudget;
  final ValueChanged<bool> onBudgetTypeChanged;

  const CategorySelectionWidget({
    super.key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
    required this.isOverallBudget,
    required this.onBudgetTypeChanged,
  });

  static const List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Food & Dining', 'icon': 'restaurant'},
    {'name': 'Transportation', 'icon': 'directions_car'},
    {'name': 'Shopping', 'icon': 'shopping_bag'},
    {'name': 'Entertainment', 'icon': 'movie'},
    {'name': 'Bills & Utilities', 'icon': 'receipt'},
    {'name': 'Healthcare', 'icon': 'local_hospital'},
    {'name': 'Education', 'icon': 'school'},
    {'name': 'Travel', 'icon': 'flight'},
    {'name': 'Personal Care', 'icon': 'spa'},
    {'name': 'Gifts & Donations', 'icon': 'card_giftcard'},
    {'name': 'Home & Garden', 'icon': 'home'},
    {'name': 'Insurance', 'icon': 'security'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Type',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onBudgetTypeChanged(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isOverallBudget
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isOverallBudget
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'account_balance_wallet',
                          color: isOverallBudget
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Overall Budget',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isOverallBudget
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: isOverallBudget
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => onBudgetTypeChanged(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: !isOverallBudget
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !isOverallBudget
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'category',
                          color: !isOverallBudget
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Category Budget',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: !isOverallBudget
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: !isOverallBudget
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!isOverallBudget) ...[
            SizedBox(height: 2.h),
            Text(
              'Select Categories',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _expenseCategories.map((category) {
                final isSelected =
                    selectedCategories.contains(category['name']);
                return GestureDetector(
                  onTap: () {
                    final updatedCategories =
                        List<String>.from(selectedCategories);
                    if (isSelected) {
                      updatedCategories.remove(category['name']);
                    } else {
                      updatedCategories.add(category['name']);
                    }
                    onCategoriesChanged(updatedCategories);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: category['icon'],
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          category['name'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            if (selectedCategories.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Text(
                '${selectedCategories.length} categories selected',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
