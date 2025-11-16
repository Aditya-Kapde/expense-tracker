import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/storage_service.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/add_income_modal.dart';
import './widgets/empty_income_state.dart';
import './widgets/income_entry_card.dart';
import './widgets/income_filter_bottom_sheet.dart';
import './widgets/income_search_bar.dart';

class IncomeManagementScreen extends StatefulWidget {
  const IncomeManagementScreen({super.key});

  @override
  State<IncomeManagementScreen> createState() => _IncomeManagementScreenState();
}

class _IncomeManagementScreenState extends State<IncomeManagementScreen> {
  List<Map<String, dynamic>> _allIncomeEntries = [];

  final List<Map<String, dynamic>> _defaultIncomes = [
    {
      'id': 1,
      'amount': 5000.00,
      'category': 'Salary',
      'categoryIcon': 'work',
      'description': 'Monthly salary from TechCorp Inc.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 2,
      'amount': 1200.00,
      'category': 'Freelance',
      'categoryIcon': 'laptop',
      'description': 'Website development project for local business',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': 3,
      'amount': 850.00,
      'category': 'Investment',
      'categoryIcon': 'trending_up',
      'description': 'Dividend payment from stock portfolio',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': 4,
      'amount': 300.00,
      'category': 'Gift',
      'categoryIcon': 'card_giftcard',
      'description': 'Birthday gift from family',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'createdAt': DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      'id': 5,
      'amount': 2000.00,
      'category': 'Bonus',
      'categoryIcon': 'star',
      'description': 'Quarterly performance bonus',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'createdAt': DateTime.now().subtract(const Duration(days: 10)),
    },
  ];

  List<Map<String, dynamic>> _filteredIncomeEntries = [];
  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {};
  final bool _isLoading = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _filteredIncomeEntries = List.from(_allIncomeEntries);
    _loadIncomes();
  }

  Future<void> _loadIncomes() async {
    final stored = StorageService.getIncomes();
    if (stored.isNotEmpty) {
      setState(() {
        _allIncomeEntries = stored;
        _filteredIncomeEntries = List.from(_allIncomeEntries);
      });
    } else {
      setState(() {
        _allIncomeEntries = List.from(_defaultIncomes);
        _filteredIncomeEntries = List.from(_allIncomeEntries);
      });
      await StorageService.saveIncomes(_allIncomeEntries);
    }
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Income Management'),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/analytics-dashboard-screen'),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: colorScheme.primary,
              size: 6.w,
            ),
            tooltip: 'View Analytics',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          IncomeSearchBar(
            initialQuery: _searchQuery,
            onSearchChanged: _handleSearchChanged,
            onFilterTap: _showFilterBottomSheet,
          ),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIncomeModal,
        tooltip: 'Add Income',
        child: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_filteredIncomeEntries.isEmpty &&
        _searchQuery.isEmpty &&
        _currentFilters.isEmpty) {
      return EmptyIncomeState(
        onAddIncome: _showAddIncomeModal,
      );
    }

    if (_filteredIncomeEntries.isEmpty) {
      return _buildNoResultsState();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 1.h,
          bottom: 10.h, // Space for FAB
        ),
        itemCount: _filteredIncomeEntries.length,
        itemBuilder: (context, index) {
          final entry = _filteredIncomeEntries[index];

          return IncomeEntryCard(
            incomeData: entry,
            onEdit: () => _editIncomeEntry(entry),
            onDelete: () => _deleteIncomeEntry(entry['id']),
          );
        },
      ),
    );
  }

  Widget _buildNoResultsState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No Results Found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No income entries match your search for "$_searchQuery"'
                  : 'No income entries match your current filters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            OutlinedButton(
              onPressed: _clearSearchAndFilters,
              child: const Text('Clear Search & Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => IncomeFilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _filteredIncomeEntries = _allIncomeEntries.where((entry) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final category = (entry['category'] as String).toLowerCase();
          final description = (entry['description'] as String).toLowerCase();
          final amount = entry['amount'].toString();

          if (!category.contains(query) &&
              !description.contains(query) &&
              !amount.contains(query)) {
            return false;
          }
        }

        // Category filter
        if (_currentFilters['category'] != null) {
          if (entry['category'] != _currentFilters['category']) {
            return false;
          }
        }

        // Date range filter
        if (_currentFilters['startDate'] != null) {
          final entryDate = entry['date'] as DateTime;
          final startDate = _currentFilters['startDate'] as DateTime;
          if (entryDate.isBefore(startDate)) {
            return false;
          }
        }

        if (_currentFilters['endDate'] != null) {
          final entryDate = entry['date'] as DateTime;
          final endDate = _currentFilters['endDate'] as DateTime;
          if (entryDate.isAfter(endDate.add(const Duration(days: 1)))) {
            return false;
          }
        }

        // Amount range filter
        if (_currentFilters['minAmount'] != null) {
          final amount = (entry['amount'] as num).toDouble();
          final minAmount = (_currentFilters['minAmount'] as num).toDouble();
          if (amount < minAmount) {
            return false;
          }
        }

        if (_currentFilters['maxAmount'] != null) {
          final amount = (entry['amount'] as num).toDouble();
          final maxAmount = (_currentFilters['maxAmount'] as num).toDouble();
          if (amount > maxAmount) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sort by date (newest first)
      _filteredIncomeEntries.sort((a, b) {
        final dateA = a['date'] as DateTime;
        final dateB = b['date'] as DateTime;
        return dateB.compareTo(dateA);
      });
    });
  }

  void _clearSearchAndFilters() {
    setState(() {
      _searchQuery = '';
      _currentFilters.clear();
      _filteredIncomeEntries = List.from(_allIncomeEntries);
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    _applyFilters();
  }

  void _showAddIncomeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddIncomeModal(
        onSave: (incomeData) async {
          setState(() {
            _allIncomeEntries.insert(0, incomeData);
          });
          await StorageService.addIncome(incomeData);
          _applyFilters();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Income entry added successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _editIncomeEntry(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddIncomeModal(
        initialData: entry,
        onSave: (updatedData) async {
          setState(() {
            final index =
                _allIncomeEntries.indexWhere((e) => e['id'] == entry['id']);
            if (index != -1) {
              _allIncomeEntries[index] = updatedData;
            }
          });
          await StorageService.saveIncomes(_allIncomeEntries);
          _applyFilters();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Income entry updated successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _deleteIncomeEntry(int id) async {
    setState(() {
      _allIncomeEntries.removeWhere((entry) => entry['id'] == id);
    });
    await StorageService.saveIncomes(_allIncomeEntries);
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Income entry deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateIncomeEntry(Map<String, dynamic> entry) async {
    final duplicatedEntry = Map<String, dynamic>.from(entry);
    duplicatedEntry['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedEntry['date'] = DateTime.now();
    duplicatedEntry['createdAt'] = DateTime.now();
    duplicatedEntry['description'] = '${entry['description']} (Copy)';

    setState(() {
      _allIncomeEntries.insert(0, duplicatedEntry);
    });
    await StorageService.saveIncomes(_allIncomeEntries);
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Income entry duplicated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareIncomeEntry(Map<String, dynamic> entry) {
    final amount = (entry['amount'] as num).toDouble();
    final category = entry['category'] as String;
    final description = entry['description'] as String;
    final date = entry['date'] as DateTime;

    final shareText = '''
Income Entry Details:
Amount: ₹${amount.toStringAsFixed(2)}
Category: $category
Description: $description
Date: ${_formatDate(date)}
    ''';

    // In a real app, you would use the share package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality: $shareText'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showIncomeDetails(Map<String, dynamic> entry) {
    final theme = Theme.of(context);
    final amount = (entry['amount'] as num).toDouble();
    final category = entry['category'] as String;
    final description = entry['description'] as String;
    final date = entry['date'] as DateTime;
    final createdAt = entry['createdAt'] as DateTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Income Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amount', '₹${amount.toStringAsFixed(2)}', theme),
            _buildDetailRow('Category', category, theme),
            if (description.isNotEmpty)
              _buildDetailRow('Description', description, theme),
            _buildDetailRow('Date', _formatDate(date), theme),
            _buildDetailRow('Created', _formatDate(createdAt), theme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _editIncomeEntry(entry);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }
}
