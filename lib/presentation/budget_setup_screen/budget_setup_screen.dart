import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/amount_input_widget.dart';
import './widgets/budget_name_input_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/smart_recommendations_widget.dart';
import './widgets/time_period_selector_widget.dart';

class BudgetSetupScreen extends StatefulWidget {
  const BudgetSetupScreen({super.key});

  @override
  State<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetNameController = TextEditingController();
  final _amountController = TextEditingController();

  TimePeriod _selectedPeriod = TimePeriod.monthly;
  List<String> _selectedCategories = [];
  bool _isOverallBudget = true;
  bool _advancedOptionsExpanded = false;
  DateTime? _startDate;
  bool _notificationsEnabled = true;
  bool _rolloverEnabled = false;

  String? _budgetNameError;
  String? _amountError;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Mock data for smart recommendations
  final List<Map<String, dynamic>> _mockRecommendations = [
    {
      'title': 'Conservative Budget',
      'amount': 800.0,
      'description': 'Based on your lowest spending months',
      'comparison': '20% below average spending',
    },
    {
      'title': 'Balanced Budget',
      'amount': 1200.0,
      'description': 'Matches your typical monthly spending',
      'comparison': 'Matches your 3-month average',
    },
    {
      'title': 'Flexible Budget',
      'amount': 1500.0,
      'description': 'Allows for occasional higher spending',
      'comparison': '25% above average spending',
    },
  ];

  final List<double> _amountSuggestions = [500, 750, 1000, 1250, 1500, 2000];

  @override
  void initState() {
    super.initState();
    _budgetNameController.addListener(_onFormChanged);
    _amountController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _budgetNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      _hasUnsavedChanges = true;
      _budgetNameError = null;
      _amountError = null;
    });
  }

  bool _validateForm() {
    bool isValid = true;

    if (_budgetNameController.text.trim().isEmpty) {
      setState(() {
        _budgetNameError = 'Budget name is required';
      });
      isValid = false;
    }

    if (_amountController.text.trim().isEmpty) {
      setState(() {
        _amountError = 'Budget amount is required';
      });
      isValid = false;
    } else {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        setState(() {
          _amountError = 'Please enter a valid amount greater than 0';
        });
        isValid = false;
      }
    }

    if (!_isOverallBudget && _selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Please select at least one category for category budget'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      isValid = false;
    }

    return isValid;
  }

  Future<void> _saveBudget() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    // Show confirmation dialog
    final confirmed = await _showSaveConfirmationDialog();
    if (!confirmed) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Budget created successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: 'View',
              textColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/budget-tracking-screen');
              },
            ),
          ),
        );

        setState(() {
          _hasUnsavedChanges = false;
        });

        // Navigate to budget tracking screen
        Navigator.pushReplacementNamed(context, '/budget-tracking-screen');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to create budget. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _showSaveConfirmationDialog() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Create Budget',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Summary:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildSummaryRow('Name', _budgetNameController.text),
                _buildSummaryRow('Amount', '₹${_amountController.text}'),
                _buildSummaryRow('Period', _getPeriodLabel(_selectedPeriod)),
                _buildSummaryRow('Type',
                    _isOverallBudget ? 'Overall Budget' : 'Category Budget'),
                if (!_isOverallBudget && _selectedCategories.isNotEmpty)
                  _buildSummaryRow(
                      'Categories', '${_selectedCategories.length} selected'),
                if (_startDate != null)
                  _buildSummaryRow('Start Date',
                      '${_startDate!.month}/${_startDate!.day}/${_startDate!.year}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Create Budget'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildSummaryRow(String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard Changes?'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to leave?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Discard'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _getPeriodLabel(TimePeriod period) {
    switch (period) {
      case TimePeriod.daily:
        return 'Daily';
      case TimePeriod.weekly:
        return 'Weekly';
      case TimePeriod.monthly:
        return 'Monthly';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Create Budget'),
          leading: IconButton(
            onPressed: () async {
              if (_hasUnsavedChanges) {
                final shouldPop = await _onWillPop();
                if (shouldPop && mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            if (_hasUnsavedChanges)
              Container(
                margin: EdgeInsets.only(right: 2.w),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            TextButton(
              onPressed: _isLoading ? null : _saveBudget,
              child: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    )
                  : const Text('Save'),
            ),
            SizedBox(width: 2.w),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Set up your budget in a few simple steps',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      LinearProgressIndicator(
                        value: _calculateProgress(),
                        backgroundColor:
                            colorScheme.outline.withValues(alpha: 0.2),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Budget Name Input
                BudgetNameInputWidget(
                  controller: _budgetNameController,
                  errorText: _budgetNameError,
                  onChanged: (value) => _onFormChanged(),
                ),
                SizedBox(height: 2.h),

                // Time Period Selector
                TimePeriodSelectorWidget(
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() {
                      _selectedPeriod = period;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 2.h),

                // Amount Input
                AmountInputWidget(
                  controller: _amountController,
                  errorText: _amountError,
                  suggestions: _amountSuggestions,
                  onChanged: (value) => _onFormChanged(),
                ),
                SizedBox(height: 2.h),

                // Smart Recommendations
                SmartRecommendationsWidget(
                  recommendations: _mockRecommendations,
                  onRecommendationSelected: (amount) {
                    _amountController.text = amount.toStringAsFixed(2);
                    _onFormChanged();
                  },
                ),
                SizedBox(height: 2.h),

                // Category Selection
                CategorySelectionWidget(
                  selectedCategories: _selectedCategories,
                  isOverallBudget: _isOverallBudget,
                  onCategoriesChanged: (categories) {
                    setState(() {
                      _selectedCategories = categories;
                      _hasUnsavedChanges = true;
                    });
                  },
                  onBudgetTypeChanged: (isOverall) {
                    setState(() {
                      _isOverallBudget = isOverall;
                      if (isOverall) {
                        _selectedCategories.clear();
                      }
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 2.h),

                // Advanced Options
                AdvancedOptionsWidget(
                  isExpanded: _advancedOptionsExpanded,
                  onToggle: () {
                    setState(() {
                      _advancedOptionsExpanded = !_advancedOptionsExpanded;
                    });
                  },
                  startDate: _startDate,
                  onStartDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                      _hasUnsavedChanges = true;
                    });
                  },
                  notificationsEnabled: _notificationsEnabled,
                  onNotificationsChanged: (enabled) {
                    setState(() {
                      _notificationsEnabled = enabled;
                      _hasUnsavedChanges = true;
                    });
                  },
                  rolloverEnabled: _rolloverEnabled,
                  onRolloverChanged: (enabled) {
                    setState(() {
                      _rolloverEnabled = enabled;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 4.h),

                // Create Budget Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _saveBudget,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              const Text('Creating Budget...'),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'add',
                                color: colorScheme.onPrimary,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              const Text('Create Budget'),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateProgress() {
    double progress = 0.0;

    if (_budgetNameController.text.isNotEmpty) progress += 0.25;
    if (_amountController.text.isNotEmpty) progress += 0.25;
    if (_isOverallBudget || _selectedCategories.isNotEmpty) progress += 0.25;
    if (_selectedPeriod != TimePeriod.monthly || _startDate != null) {
      progress += 0.25;
    }

    return progress;
  }
}
