import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/chart_type_selector.dart';
import './widgets/expense_categorization_chart.dart';
import './widgets/export_options_sheet.dart';
import './widgets/income_distribution_chart.dart';
import './widgets/remaining_funds_chart.dart';
import './widgets/summary_metrics_cards.dart';
import './widgets/time_period_selector.dart';
import './widgets/trend_comparison_chart.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with TickerProviderStateMixin {
  TimePeriod _selectedPeriod = TimePeriod.monthly;
  ChartType _selectedChartType = ChartType.pie;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(TimePeriod period) {
    if (period != _selectedPeriod) {
      setState(() {
        _isLoading = true;
        _selectedPeriod = period;
      });

      // Simulate data loading with smooth transition
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _animationController.reset();
          _animationController.forward();
        }
      });
    }
  }

  void _onChartTypeChanged(ChartType type) {
    setState(() {
      _selectedChartType = type;
    });
    HapticFeedback.selectionClick();
  }

  void _showExportOptions() {
    HapticFeedback.mediumImpact();
    ExportOptionsSheet.show(
      context,
      onExportPDF: _exportPDF,
      onExportCSV: _exportCSV,
      onShareChart: _shareChart,
    );
  }

  void _exportPDF() {
    // Mock PDF export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('PDF report exported successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _exportCSV() {
    // Mock CSV export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('CSV data exported successfully!'),
        backgroundColor: const Color(0xFF388E3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareChart() {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chart image shared successfully!'),
        backgroundColor: const Color(0xFF1976D2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _getPeriodString() {
    switch (_selectedPeriod) {
      case TimePeriod.daily:
        return 'Daily';
      case TimePeriod.weekly:
        return 'Weekly';
      case TimePeriod.monthly:
        return 'Monthly';
      case TimePeriod.yearly:
        return 'Yearly';
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'Loading analytics...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'analytics',
              color: colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Data Available',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Add more transactions to see meaningful analytics and insights.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/income-management-screen'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('Add Transaction'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: _showExportOptions,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Export Options',
          ),
          IconButton(
            onPressed: () {
              // Navigate to settings or more options
              Navigator.pushNamed(context, '/dashboard-home-screen');
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'More Options',
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(milliseconds: 1000));
              setState(() => _isLoading = false);
              _animationController.reset();
              _animationController.forward();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Period Selector
                  TimePeriodSelector(
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: _onPeriodChanged,
                  ),

                  SizedBox(height: 2.h),

                  // Chart Type Selector
                  ChartTypeSelector(
                    selectedType: _selectedChartType,
                    onTypeChanged: _onChartTypeChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Main Charts Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        children: [
                          // Income Distribution Chart
                          IncomeDistributionChart(
                            timePeriod: _getPeriodString(),
                          ),

                          SizedBox(height: 3.h),

                          // Expense Categorization Chart
                          ExpenseCategorization(
                            timePeriod: _getPeriodString(),
                          ),

                          SizedBox(height: 3.h),

                          // Remaining Funds Chart
                          RemainingFundsChart(
                            timePeriod: _getPeriodString(),
                          ),

                          SizedBox(height: 3.h),

                          // Trend Comparison Chart
                          TrendComparisonChart(
                            timePeriod: _getPeriodString(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Summary Metrics Cards
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SummaryMetricsCards(
                      timePeriod: _getPeriodString(),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Quick Actions Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/income-management-screen'),
                                icon: CustomIconWidget(
                                  iconName: 'trending_up',
                                  color: colorScheme.onPrimary,
                                  size: 20,
                                ),
                                label: const Text('Add Income'),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.5.h),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/expense-management-screen'),
                                icon: CustomIconWidget(
                                  iconName: 'trending_down',
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                label: const Text('Add Expense'),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.5.h),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () => Navigator.pushNamed(
                                context, '/budget-setup-screen'),
                            icon: CustomIconWidget(
                              iconName: 'account_balance_wallet',
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            label: const Text('Manage Budget'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),

      // Floating Action Button for quick export
      floatingActionButton: FloatingActionButton(
        onPressed: _showExportOptions,
        tooltip: 'Export Analytics',
        child: CustomIconWidget(
          iconName: 'file_download',
          color: colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}
