import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddExpenseModalWidget extends StatefulWidget {
  final Map<String, dynamic>? expense;
  final Function(Map<String, dynamic>) onSave;

  const AddExpenseModalWidget({
    super.key,
    this.expense,
    required this.onSave,
  });

  @override
  State<AddExpenseModalWidget> createState() => _AddExpenseModalWidgetState();
}

class _AddExpenseModalWidgetState extends State<AddExpenseModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': 'restaurant', 'color': Color(0xFFFF6B6B)},
    {'name': 'Transport', 'icon': 'directions_car', 'color': Color(0xFF4ECDC4)},
    {
      'name': 'Utilities',
      'icon': 'electrical_services',
      'color': Color(0xFFFFE66D)
    },
    {'name': 'Entertainment', 'icon': 'movie', 'color': Color(0xFFFF8B94)},
    {'name': 'Shopping', 'icon': 'shopping_bag', 'color': Color(0xFFA8E6CF)},
    {
      'name': 'Healthcare',
      'icon': 'local_hospital',
      'color': Color(0xFFFFAB91)
    },
    {'name': 'Education', 'icon': 'school', 'color': Color(0xFF81C784)},
    {'name': 'Travel', 'icon': 'flight', 'color': Color(0xFF64B5F6)},
    {'name': 'Fitness', 'icon': 'fitness_center', 'color': Color(0xFFBA68C8)},
    {
      'name': 'Groceries',
      'icon': 'local_grocery_store',
      'color': Color(0xFF4DB6AC)
    },
    {'name': 'Other', 'icon': 'category', 'color': Color(0xFF9E9E9E)},
  ];

  final List<String> _merchantSuggestions = [
    'Starbucks',
    'McDonald\'s',
    'Walmart',
    'Target',
    'Amazon',
    'Uber',
    'Netflix',
    'Spotify',
    'Gas Station',
    'Pharmacy',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!["amount"].toString();
      _descriptionController.text = widget.expense!["description"] ?? '';
      _selectedCategory = widget.expense!["category"] ?? 'Food';
      _selectedDate = widget.expense!["date"] ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAmountInput(context),
                    SizedBox(height: 3.h),
                    _buildCategorySelection(context),
                    SizedBox(height: 3.h),
                    _buildDescriptionInput(context),
                    SizedBox(height: 3.h),
                    _buildDateSelection(context),
                    SizedBox(height: 4.h),
                    _buildSaveButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          Expanded(
            child: Text(
              widget.expense != null ? 'Edit Expense' : 'Add Expense',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 12.w), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildAmountInput(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            prefixIcon: Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                '\$',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelection(BuildContext context) {
    final theme = Theme.of(context);

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
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];

              return Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'];
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? category['color']
                              : category['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: category['color'],
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: category['icon'],
                            color:
                                isSelected ? Colors.white : category['color'],
                            size: 7.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        category['name'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionInput(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Enter description or merchant name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),
        Text(
          'Suggestions:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 0.5.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _merchantSuggestions.map((suggestion) {
            return GestureDetector(
              onTap: () {
                _descriptionController.text = suggestion;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  suggestion,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSelection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveExpense,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Text(
          widget.expense != null ? 'Update Expense' : 'Add Expense',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expenseData = {
        'id': widget.expense?['id'] ?? DateTime.now().millisecondsSinceEpoch,
        'amount': double.parse(_amountController.text),
        'category': _selectedCategory,
        'description': _descriptionController.text,
        'date': _selectedDate,
      };

      widget.onSave(expenseData);
      Navigator.pop(context);
    }
  }
}
