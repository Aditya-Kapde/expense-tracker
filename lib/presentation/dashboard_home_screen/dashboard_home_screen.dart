import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/budget_progress_card.dart';
import './widgets/financial_summary_card.dart';
import './widgets/greeting_header.dart';
import './widgets/quick_action_fab.dart';
import './widgets/recent_transaction_item.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock data for financial summary
  final Map<String, dynamic> _financialData = {
    'totalIncome': 5420.50,
    'totalExpenses': 3280.75,
    'savings': 2139.75,
  };

  // Mock data for budget progress
  final List<Map<String, dynamic>> _budgetData = [
    {
      'name': 'Monthly Budget',
      'spent': 2850.00,
      'total': 4000.00,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Food & Dining',
      'spent': 680.50,
      'total': 800.00,
      'color': const Color(0xFFF57C00),
    },
    {
      'name': 'Transportation',
      'spent': 320.00,
      'total': 400.00,
      'color': const Color(0xFF2196F3),
    },
  ];

  // Mock data for recent transactions
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 1,
      'type': 'expense',
      'amount': 45.50,
      'category': 'Food',
      'description': 'Lunch at Downtown Cafe',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': 2,
      'type': 'income',
      'amount': 2500.00,
      'category': 'Salary',
      'description': 'Monthly Salary Payment',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 3,
      'type': 'expense',
      'amount': 89.99,
      'category': 'Shopping',
      'description': 'Online Shopping - Electronics',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 4,
      'type': 'expense',
      'amount': 25.00,
      'category': 'Transport',
      'description': 'Uber Ride to Office',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': 5,
      'type': 'income',
      'amount': 150.00,
      'category': 'Freelance',
      'description': 'Web Design Project',
      'date': DateTime.now().subtract(const Duration(days: 4)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
  }

  void _startAnimations() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Greeting Header
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) => FadeTransition(
                    opacity: _fadeAnimation,
                    child: const GreetingHeader(
                      userName: 'Abhish kapdekar',
                    ),
                  ),
                ),
              ),

              // Financial Summary Cards
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FinancialSummaryCard(
                                  title: 'Total Income',
                                  amount:
                                      '₹${_financialData['totalIncome'].toStringAsFixed(2)}',
                                  backgroundColor: AppTheme.getSuccessColor(
                                          theme.brightness == Brightness.light)
                                      .withValues(alpha: 0.1),
                                  textColor: AppTheme.getSuccessColor(
                                      theme.brightness == Brightness.light),
                                  icon: Icons.trending_up,
                                  onTap: () => Navigator.pushNamed(
                                      context, '/income-management-screen'),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: FinancialSummaryCard(
                                  title: 'Total Expenses',
                                  amount:
                                      '₹${_financialData['totalExpenses'].toStringAsFixed(2)}',
                                  backgroundColor: theme.colorScheme.error
                                      .withValues(alpha: 0.1),
                                  textColor: theme.colorScheme.error,
                                  icon: Icons.trending_down,
                                  onTap: () => Navigator.pushNamed(
                                      context, '/expense-management-screen'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.w),
                          FinancialSummaryCard(
                            title: 'Total Savings',
                            amount:
                                '₹${_financialData['savings'].toStringAsFixed(2)}',
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            textColor: theme.colorScheme.primary,
                            icon: Icons.account_balance_wallet,
                            onTap: () => Navigator.pushNamed(
                                context, '/analytics-dashboard-screen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 4.h)),

              // Budget Status Section
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) => FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Budget Status',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/budget-tracking-screen'),
                                child: Text(
                                  'View All',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          ...(_budgetData
                              .map((budget) => BudgetProgressCard(
                                    budgetName: budget['name'] as String,
                                    spent: budget['spent'] as double,
                                    total: budget['total'] as double,
                                    progressColor: budget['color'] as Color,
                                  ))
                              .toList()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

              // Recent Transactions Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, '/expense-management-screen'),
                        child: Text(
                          'View All',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Transactions List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _recentTransactions.length) return null;

                    return AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) => FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: RecentTransactionItem(
                            transaction: _recentTransactions[index],
                            onEdit: () =>
                                _editTransaction(_recentTransactions[index]),
                            onDelete: () =>
                                _deleteTransaction(_recentTransactions[index]),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _recentTransactions.length,
                ),
              ),

              // Bottom spacing for FAB
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) => FadeTransition(
          opacity: _fadeAnimation,
          child: QuickActionFab(
            onAddTransaction: _handleAddTransaction,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        variant: CustomBottomBarVariant.navigation,
        currentIndex: 0,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call with haptic feedback
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdated = DateTime.now();
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Financial data updated successfully'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleAddTransaction() {
    // Refresh data after adding transaction
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }

  void _editTransaction(Map<String, dynamic> transaction) {
    // Navigate to edit transaction screen or show edit modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Transaction'),
        content: Text('Edit transaction: ${transaction['description']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction updated successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteTransaction(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction "${transaction['description']}" deleted'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Restore transaction
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transaction restored'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getBudgetProgressColor(double spent, double total) {
    final progress = spent / total;
    if (progress >= 1.0) {
      return Theme.of(context).colorScheme.error;
    } else if (progress >= 0.8) {
      return AppTheme.getWarningColor(
          Theme.of(context).brightness == Brightness.light);
    } else {
      return AppTheme.getSuccessColor(
          Theme.of(context).brightness == Brightness.light);
    }
  }
}

