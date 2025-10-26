import 'package:flutter/material.dart';
import '../presentation/income_management_screen/income_management_screen.dart';
import '../presentation/budget_setup_screen/budget_setup_screen.dart';
import '../presentation/dashboard_home_screen/dashboard_home_screen.dart';
import '../presentation/budget_tracking_screen/budget_tracking_screen.dart';
import '../presentation/analytics_dashboard_screen/analytics_dashboard_screen.dart';
import '../presentation/expense_management_screen/expense_management_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String incomeManagement = '/income-management-screen';
  static const String budgetSetup = '/budget-setup-screen';
  static const String dashboardHome = '/dashboard-home-screen';
  static const String budgetTracking = '/budget-tracking-screen';
  static const String analyticsDashboard = '/analytics-dashboard-screen';
  static const String expenseManagement = '/expense-management-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardHomeScreen(),
    incomeManagement: (context) => const IncomeManagementScreen(),
    budgetSetup: (context) => const BudgetSetupScreen(),
    dashboardHome: (context) => const DashboardHomeScreen(),
    budgetTracking: (context) => const BudgetTrackingScreen(),
    analyticsDashboard: (context) => const AnalyticsDashboardScreen(),
    expenseManagement: (context) => const ExpenseManagementScreen(),
    // TODO: Add your other routes here
  };
}
