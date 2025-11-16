import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddIncomeModal extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final ValueChanged<Map<String, dynamic>>? onSave;

  const AddIncomeModal({
    super.key,
    this.initialData,
    this.onSave,
  });

  @override
  State<AddIncomeModal> createState() => _AddIncomeModalState();
}

class _AddIncomeModalState extends State<AddIncomeModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'Salary';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Salary', 'icon': 'work', 'color': Colors.blue},
    {'name': 'Freelance', 'icon': 'laptop', 'color': Colors.purple},
    {'name': 'Investment', 'icon': 'trending_up', 'color': Colors.green},
    {'name': 'Business', 'icon': 'business', 'color': Colors.orange},
    {'name': 'Gift', 'icon': 'card_giftcard', 'color': Colors.pink},
    {'name': 'Bonus', 'icon': 'star', 'color': Colors.amber},
    {'name': 'Other', 'icon': 'more_horiz', 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final data = widget.initialData!;
    _amountController.text = (data['amount'] as num?)?.toString() ?? '';
    _descriptionController.text = data['description'] as String? ?? '';
    _selectedCategory = data['category'] as String? ?? 'Salary';
    _selectedDate = data['date'] as DateTime? ?? DateTime.now();
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
    final isEditing = widget.initialData != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Income' : 'Add Income'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          if (_isLoading)
            Container(
              margin: EdgeInsets.only(right: 4.w),
              child: Center(
                child: SizedBox(
                  width: 5.w,
                  height: 5.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveIncome,
              child: Text(
                isEditing ? 'Update' : 'Save',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              _buildAmountSection(theme),
              SizedBox(height: 3.h),

              // Category Selection
              _buildCategorySection(theme),
              SizedBox(height: 3.h),

              // Description Input
              _buildDescriptionSection(theme),
              SizedBox(height: 3.h),

              // Date Selection
              _buildDateSection(theme),
              SizedBox(height: 4.h),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveIncome,
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(isEditing ? 'Updating...' : 'Saving...'),
                          ],
                        )
                      : Text(isEditing ? 'Update Income' : 'Add Income'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(ThemeData theme) {
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
          decoration: InputDecoration(
            hintText: '0.00',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Text(
                '₹',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
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
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                },
                child: Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: (category['color'] as Color)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: category['icon'],
                            color: category['color'],
                            size: 6.w,
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
                              : theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Add a note about this income...',
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection(ThemeData theme) {
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
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
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
                  _formatDate(_selectedDate),
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

  Future<void> _selectDate() async {
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

  void _saveIncome() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final selectedCategoryData = _categories.firstWhere(
      (cat) => cat['name'] == _selectedCategory,
    );

    final incomeData = {
      'id': widget.initialData?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'amount': double.parse(_amountController.text),
      'category': _selectedCategory,
      'categoryIcon': selectedCategoryData['icon'],
      'description': _descriptionController.text.trim(),
      'date': _selectedDate,
      'createdAt': widget.initialData?['createdAt'] ?? DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    setState(() {
      _isLoading = false;
    });

    widget.onSave?.call(incomeData);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}
