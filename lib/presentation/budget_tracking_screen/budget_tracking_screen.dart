import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/budget_alert_widget.dart';
import './widgets/budget_progress_card_widget.dart';
import './widgets/period_selector_widget.dart';
import './widgets/quick_expense_fab_widget.dart';
import './widgets/spending_velocity_widget.dart';

class BudgetTrackingScreen extends StatefulWidget {
  const BudgetTrackingScreen({super.key});

  @override
  State<BudgetTrackingScreen> createState() => _BudgetTrackingScreenState();
}

class _BudgetTrackingScreenState extends State<BudgetTrackingScreen>
    with SingleTickerProviderStateMixin {
  String _selectedPeriod = 'monthly';
  bool _isRefreshing = false;
  late DateTime _lastSyncTime;

  // Mock data for budget tracking
  final List<Map<String, dynamic>> _budgetData = [
    {
      'id': 1,
      'name': 'Groceries & Food',
      'amount': 800.0,
      'spent': 520.75,
      'period': 'monthly',
      'daysRemaining': 12,
      'category': 'Food & Dining',
    },
    {
      'id': 2,
      'name': 'Transportation',
      'amount': 300.0,
      'spent': 285.50,
      'period': 'monthly',
      'daysRemaining': 12,
      'category': 'Transport',
    },
    {
      'id': 3,
      'name': 'Entertainment',
      'amount': 200.0,
      'spent': 145.25,
      'period': 'monthly',
      'daysRemaining': 12,
      'category': 'Entertainment',
    },
    {
      'id': 4,
      'name': 'Shopping',
      'amount': 400.0,
      'spent': 425.80,
      'period': 'monthly',
      'daysRemaining': 12,
      'category': 'Shopping',
    },
    {
      'id': 5,
      'name': 'Weekly Coffee',
      'amount': 50.0,
      'spent': 32.50,
      'period': 'weekly',
      'daysRemaining': 3,
      'category': 'Food & Dining',
    },
    {
      'id': 6,
      'name': 'Daily Lunch',
      'amount': 25.0,
      'spent': 18.75,
      'period': 'daily',
      'daysRemaining': 1,
      'category': 'Food & Dining',
    },
  ];

  final List<Map<String, dynamic>> _alertsData = [
    {
      'id': 1,
      'type': 'exceeded',
      'title': 'Budget Exceeded',
      'message': 'You have exceeded your shopping budget by \$25.80',
      'budgetName': 'Shopping',
      'amount': 25.80,
    },
    {
      'id': 2,
      'type': 'warning',
      'title': 'Budget Warning',
      'message': 'You\'re approaching your transportation budget limit',
      'budgetName': 'Transportation',
      'amount': 285.50,
    },
  ];

  final Map<String, dynamic> _velocityData = {
    'currentPace': 45.50,
    'projectedSpend': 1420.0,
    'budgetLimit': 1700.0,
    'status': 'on_track',
    'message': 'You\'re on track with your spending this month',
  };

  @override
  void initState() {
    super.initState();
    _lastSyncTime = DateTime.now();
  }

  List<Map<String, dynamic>> get _filteredBudgets {
    return ((_budgetData as List)
        .where((budget) =>
            (budget as Map<String, dynamic>)['period'] == _selectedPeriod)
        .toList() as List<Map<String, dynamic>>);
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastSyncTime = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget data refreshed successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onBudgetCardTap(Map<String, dynamic> budget) {
    Navigator.pushNamed(context, '/expense-management-screen');
  }

  void _onBudgetCardLongPress(Map<String, dynamic> budget) {
    _showBudgetActions(budget);
  }

  void _showBudgetActions(Map<String, dynamic> budget) {
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              budget['name'] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Edit Budget'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/budget-setup-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                size: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: const Text('View History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/analytics-dashboard-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'pause',
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: const Text('Pause Tracking'),
              onTap: () {
                Navigator.pop(context);
                _pauseBudgetTracking(budget);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _pauseBudgetTracking(Map<String, dynamic> budget) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Paused tracking for ${budget['name']}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Resume tracking logic
          },
        ),
      ),
    );
  }

  void _dismissAlert(int alertId) {
    setState(() {
      _alertsData.removeWhere((alert) => (alert['id'] as int) == alertId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracking'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/budget-setup-screen'),
            icon: CustomIconWidget(
              iconName: 'add',
              size: 24,
              color: colorScheme.onSurface,
            ),
            tooltip: 'Add Budget',
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/analytics-dashboard-screen'),
            icon: CustomIconWidget(
              iconName: 'analytics',
              size: 24,
              color: colorScheme.onSurface,
            ),
            tooltip: 'Analytics',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            // Period selector
            SliverToBoxAdapter(
              child: PeriodSelectorWidget(
                selectedPeriod: _selectedPeriod,
                onPeriodChanged: (period) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
              ),
            ),

            // Alerts section
            if (_alertsData.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final alert = _alertsData[index];
                    return BudgetAlertWidget(
                      alertData: alert,
                      onDismiss: () => _dismissAlert(alert['id'] as int),
                    );
                  },
                  childCount: _alertsData.length,
                ),
              ),

            // Budget progress cards
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final budget = _filteredBudgets[index];
                  return BudgetProgressCardWidget(
                    budgetData: budget,
                    onTap: () => _onBudgetCardTap(budget),
                    onLongPress: () => _onBudgetCardLongPress(budget),
                  );
                },
                childCount: _filteredBudgets.length,
              ),
            ),

            // Spending velocity
            SliverToBoxAdapter(
              child: SpendingVelocityWidget(
                velocityData: _velocityData,
              ),
            ),

            // Last sync info
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(4.w),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'sync',
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last synced: ${_formatSyncTime(_lastSyncTime)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (_isRefreshing)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom spacing for FAB
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      floatingActionButton: QuickExpenseFabWidget(
        onExpenseAdded: () {
          setState(() {
            // Refresh budget data after expense is added
          });
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 3, // Budget tracking is at index 3
        onTap: (index) {
          // Navigation handled by CustomBottomBar
        },
      ),
    );
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
