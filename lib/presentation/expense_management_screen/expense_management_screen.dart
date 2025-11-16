import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/storage_service.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/add_expense_modal_widget.dart';
import './widgets/expense_card_widget.dart';
import './widgets/expense_filter_widget.dart';
import './widgets/expense_search_widget.dart';
import './widgets/expense_summary_widget.dart';

class ExpenseManagementScreen extends StatefulWidget {
  const ExpenseManagementScreen({super.key});

  @override
  State<ExpenseManagementScreen> createState() =>
      _ExpenseManagementScreenState();
}

class _ExpenseManagementScreenState extends State<ExpenseManagementScreen> {
  List<Map<String, dynamic>> _allExpenses = [];

  final List<Map<String, dynamic>> _defaultExpenses = [
    {
      "id": 1,
      "amount": 45.50,
      "category": "Food",
      "description": "Starbucks Coffee",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "amount": 120.00,
      "category": "Groceries",
      "description": "Walmart Grocery Shopping",
      "date": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 3,
      "amount": 25.75,
      "category": "Transport",
      "description": "Uber Ride",
      "date": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 4,
      "amount": 89.99,
      "category": "Utilities",
      "description": "Electric Bill",
      "date": DateTime.now().subtract(const Duration(days: 2)),
    },
  ];
  List<Map<String, dynamic>> _filteredExpenses = [];
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final stored = StorageService.getExpenses();
    if (stored.isNotEmpty) {
      setState(() {
        _allExpenses = stored;
        _filteredExpenses = List.from(_allExpenses);
      });
    } else {
      setState(() {
        _allExpenses = List.from(_defaultExpenses);
        _filteredExpenses = List.from(_allExpenses);
      });
      await StorageService.saveExpenses(_allExpenses);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            onPressed: () => _showSortOptions(context),
            icon: CustomIconWidget(
              iconName: 'sort',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () => _exportExpenses(),
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ExpenseSearchWidget(
            onSearchChanged: _onSearchChanged,
            onFilterTap: _showFilterModal,
            hasActiveFilters: _activeFilters.isNotEmpty,
          ),
          if (_filteredExpenses.isNotEmpty) ...[
            ExpenseSummaryWidget(
              expenses: _filteredExpenses,
              filters: _activeFilters,
            ),
          ],
          Expanded(
            child: _buildExpenseList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseModal,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 7.w,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildExpenseList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_filteredExpenses.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshExpenses,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: _filteredExpenses.length,
        itemBuilder: (context, index) {
          final expense = _filteredExpenses[index];
          return ExpenseCardWidget(
            expense: expense,
            onTap: () => _showExpenseDetails(expense),
            onEdit: () => _editExpense(expense),
            onDelete: () => _deleteExpense(expense),
            onDuplicate: () => _duplicateExpense(expense),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'receipt_long',
                  color: colorScheme.primary,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'No expenses found'
                  : 'No expenses yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Start tracking your expenses by adding your first transaction',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            if (_searchQuery.isEmpty && _activeFilters.isEmpty) ...[
              ElevatedButton.icon(
                onPressed: _showAddExpenseModal,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: const Text('Add First Expense'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                ),
              ),
            ] else ...[
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem('Dashboard', 'dashboard', '/dashboard-home-screen'),
              _buildNavItem(
                  'Income', 'trending_up', '/income-management-screen'),
              _buildNavItem(
                  'Expenses', 'trending_down', '/expense-management-screen',
                  isActive: true),
              _buildNavItem('Budget', 'account_balance_wallet',
                  '/budget-tracking-screen'),
              _buildNavItem(
                  'Analytics', 'analytics', '/analytics-dashboard-screen'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, String iconName, String route,
      {bool isActive = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: isActive ? null : () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExpenseFilterWidget(
        currentFilters: _activeFilters,
        onFilterApplied: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseModalWidget(
        onSave: _addExpense,
      ),
    );
  }

  void _showExpenseDetails(Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense['description']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ₹${expense['amount'].toStringAsFixed(2)}'),
            Text('Category: ${expense['category']}'),
            Text('Date: ${_formatDate(expense['date'])}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editExpense(expense);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _editExpense(Map<String, dynamic> expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseModalWidget(
        expense: expense,
        onSave: _updateExpense,
      ),
    );
  }

  Future<void> _addExpense(Map<String, dynamic> expenseData) async {
    setState(() {
      _allExpenses.insert(0, expenseData);
      _applyFilters();
    });

    await StorageService.addExpense(expenseData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _updateExpense(Map<String, dynamic> updatedExpense) async {
    setState(() {
      final index =
          _allExpenses.indexWhere((e) => e['id'] == updatedExpense['id']);
      if (index != -1) {
        _allExpenses[index] = updatedExpense;
        _applyFilters();
      }
    });

    await StorageService.saveExpenses(_allExpenses);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteExpense(Map<String, dynamic> expense) async {
    final deletedExpense = expense;
    final deletedIndex =
        _allExpenses.indexWhere((e) => e['id'] == expense['id']);

    setState(() {
      _allExpenses.removeWhere((e) => e['id'] == expense['id']);
      _applyFilters();
    });
    await StorageService.saveExpenses(_allExpenses);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              _allExpenses.insert(deletedIndex, deletedExpense);
              _applyFilters();
            });
            await StorageService.saveExpenses(_allExpenses);
          },
        ),
      ),
    );
  }

  Future<void> _duplicateExpense(Map<String, dynamic> expense) async {
    final duplicatedExpense = Map<String, dynamic>.from(expense);
    duplicatedExpense['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedExpense['date'] = DateTime.now();

    setState(() {
      _allExpenses.insert(0, duplicatedExpense);
      _applyFilters();
    });

    await StorageService.saveExpenses(_allExpenses);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense duplicated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allExpenses);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((expense) {
        final description =
            expense['description']?.toString().toLowerCase() ?? '';
        final category = expense['category']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return description.contains(query) || category.contains(query);
      }).toList();
    }

    // Apply date range filter
    if (_activeFilters.containsKey('startDate') &&
        _activeFilters.containsKey('endDate')) {
      final startDate = _activeFilters['startDate'] as DateTime;
      final endDate = _activeFilters['endDate'] as DateTime;
      filtered = filtered.where((expense) {
        final expenseDate = expense['date'] as DateTime;
        return expenseDate
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            expenseDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply category filter
    if (_activeFilters.containsKey('categories')) {
      final selectedCategories = _activeFilters['categories'] as List<String>;
      if (selectedCategories.isNotEmpty) {
        filtered = filtered.where((expense) {
          return selectedCategories.contains(expense['category']);
        }).toList();
      }
    }

    // Apply amount range filter
    if (_activeFilters.containsKey('amountRange')) {
      final amountRange = _activeFilters['amountRange'] as RangeValues;
      filtered = filtered.where((expense) {
        final amount = expense['amount'] as double;
        return amount >= amountRange.start && amount <= amountRange.end;
      }).toList();
    }

    setState(() {
      _filteredExpenses = filtered;
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _activeFilters.clear();
      _filteredExpenses = List.from(_allExpenses);
    });
  }

  Future<void> _refreshExpenses() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expenses refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'calendar_today',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Date (Newest First)'),
              onTap: () {
                _sortExpenses('date_desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'calendar_today',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Date (Oldest First)'),
              onTap: () {
                _sortExpenses('date_asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'attach_money',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Amount (Highest First)'),
              onTap: () {
                _sortExpenses('amount_desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'attach_money',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Amount (Lowest First)'),
              onTap: () {
                _sortExpenses('amount_asc');
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _sortExpenses(String sortType) {
    setState(() {
      switch (sortType) {
        case 'date_desc':
          _filteredExpenses.sort((a, b) =>
              (b['date'] as DateTime).compareTo(a['date'] as DateTime));
          break;
        case 'date_asc':
          _filteredExpenses.sort((a, b) =>
              (a['date'] as DateTime).compareTo(b['date'] as DateTime));
          break;
        case 'amount_desc':
          _filteredExpenses.sort((a, b) =>
              (b['amount'] as double).compareTo(a['amount'] as double));
          break;
        case 'amount_asc':
          _filteredExpenses.sort((a, b) =>
              (a['amount'] as double).compareTo(b['amount'] as double));
          break;
      }
    });
  }

  void _exportExpenses() {
    // Simulate export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expenses exported successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';

    DateTime dateTime;
    if (date is DateTime) {
      dateTime = date;
    } else if (date is String) {
      dateTime = DateTime.tryParse(date) ?? DateTime.now();
    } else {
      return '';
    }

    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}
