import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickExpenseFabWidget extends StatefulWidget {
  final VoidCallback? onExpenseAdded;

  const QuickExpenseFabWidget({
    super.key,
    this.onExpenseAdded,
  });

  @override
  State<QuickExpenseFabWidget> createState() => _QuickExpenseFabWidgetState();
}

class _QuickExpenseFabWidgetState extends State<QuickExpenseFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _quickCategories = [
    {
      'name': 'Food',
      'icon': 'restaurant',
      'color': Colors.orange,
    },
    {
      'name': 'Transport',
      'icon': 'directions_car',
      'color': Colors.blue,
    },
    {
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'color': Colors.purple,
    },
    {
      'name': 'Bills',
      'icon': 'receipt',
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _addQuickExpense(String category) {
    _showQuickExpenseDialog(category);
    _toggleExpansion();
  }

  void _showQuickExpenseDialog(String category) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $category Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                // Process the expense addition
                _processQuickExpense(
                  category,
                  double.tryParse(amountController.text) ?? 0.0,
                  descriptionController.text,
                );
                Navigator.pop(context);
                widget.onExpenseAdded?.call();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _processQuickExpense(
      String category, double amount, String description) {
    // Here you would typically save the expense to your data source
    // For now, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Added \$${amount.toStringAsFixed(2)} expense to $category'),
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.dark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Quick category buttons
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: _quickCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final delay = index * 0.1;

                return Transform.scale(
                  scale: _animation.value,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: FloatingActionButton.small(
                        heroTag: 'quick_${category['name']}',
                        onPressed: () =>
                            _addQuickExpense(category['name'] as String),
                        backgroundColor: category['color'] as Color,
                        child: CustomIconWidget(
                          iconName: category['icon'] as String,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),

        // Main FAB
        FloatingActionButton(
          heroTag: 'main_fab',
          onPressed: _toggleExpansion,
          backgroundColor: colorScheme.primary,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: CustomIconWidget(
              iconName: _isExpanded ? 'close' : 'add',
              size: 24,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
