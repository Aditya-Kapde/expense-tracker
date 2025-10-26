import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class IncomeFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersApplied;

  const IncomeFilterBottomSheet({
    super.key,
    this.currentFilters,
    this.onFiltersApplied,
  });

  @override
  State<IncomeFilterBottomSheet> createState() =>
      _IncomeFilterBottomSheetState();
}

class _IncomeFilterBottomSheetState extends State<IncomeFilterBottomSheet> {
  late Map<String, dynamic> _filters;
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();

  final List<String> _categories = [
    'All Categories',
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Gift',
    'Bonus',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters ?? {});

    if (_filters['minAmount'] != null) {
      _minAmountController.text = _filters['minAmount'].toString();
    }
    if (_filters['maxAmount'] != null) {
      _maxAmountController.text = _filters['maxAmount'].toString();
    }
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Income',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Date Range
          _buildDateRangeSection(theme),
          SizedBox(height: 3.h),

          // Category Filter
          _buildCategorySection(theme),
          SizedBox(height: 3.h),

          // Amount Range
          _buildAmountRangeSection(theme),
          SizedBox(height: 4.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: FilledButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(context, 'startDate'),
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: colorScheme.primary,
                  size: 4.w,
                ),
                label: Text(
                  _filters['startDate'] != null
                      ? _formatDate(_filters['startDate'])
                      : 'Start Date',
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(context, 'endDate'),
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: colorScheme.primary,
                  size: 4.w,
                ),
                label: Text(
                  _filters['endDate'] != null
                      ? _formatDate(_filters['endDate'])
                      : 'End Date',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories.map((category) {
            final isSelected = _filters['category'] == category ||
                (category == 'All Categories' && _filters['category'] == null);

            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['category'] =
                      selected && category != 'All Categories'
                          ? category
                          : null;
                });
              },
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Min Amount',
                  prefixText: '\$',
                ),
                onChanged: (value) {
                  _filters['minAmount'] = double.tryParse(value);
                },
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextField(
                controller: _maxAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max Amount',
                  prefixText: '\$',
                ),
                onChanged: (value) {
                  _filters['maxAmount'] = double.tryParse(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filters[dateType] ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _filters[dateType] = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _minAmountController.clear();
      _maxAmountController.clear();
    });
  }

  void _applyFilters() {
    // Remove null values
    final cleanFilters = Map<String, dynamic>.from(_filters);
    cleanFilters.removeWhere((key, value) => value == null);

    widget.onFiltersApplied?.call(cleanFilters);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }
}
