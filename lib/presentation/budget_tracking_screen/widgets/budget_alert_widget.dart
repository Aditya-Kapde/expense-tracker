import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetAlertWidget extends StatelessWidget {
  final Map<String, dynamic> alertData;
  final VoidCallback? onDismiss;

  const BudgetAlertWidget({
    super.key,
    required this.alertData,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final String alertType = alertData['type'] as String? ?? 'warning';
    final String title = alertData['title'] as String? ?? 'Budget Alert';
    final String message =
        alertData['message'] as String? ?? 'You have a budget notification';
    final String budgetName =
        alertData['budgetName'] as String? ?? 'Unknown Budget';
    final double amount = (alertData['amount'] as num?)?.toDouble() ?? 0.0;

    // Determine alert styling based on type
    Color alertColor;
    IconData alertIcon;
    Color backgroundColor;

    switch (alertType) {
      case 'exceeded':
        alertColor = theme.colorScheme.error;
        alertIcon = Icons.error_outline;
        backgroundColor = theme.colorScheme.error.withValues(alpha: 0.1);
        break;
      case 'warning':
        alertColor = AppTheme.getWarningColor(isDark);
        alertIcon = Icons.warning_outlined;
        backgroundColor =
            AppTheme.getWarningColor(isDark).withValues(alpha: 0.1);
        break;
      case 'info':
        alertColor = AppTheme.getInfoColor(isDark);
        alertIcon = Icons.info_outline;
        backgroundColor = AppTheme.getInfoColor(isDark).withValues(alpha: 0.1);
        break;
      default:
        alertColor = AppTheme.getSuccessColor(isDark);
        alertIcon = Icons.check_circle_outline;
        backgroundColor =
            AppTheme.getSuccessColor(isDark).withValues(alpha: 0.1);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Alert icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: alertIcon == Icons.error_outline
                  ? 'error_outline'
                  : alertIcon == Icons.warning_outlined
                      ? 'warning'
                      : alertIcon == Icons.info_outline
                          ? 'info'
                          : 'check_circle',
              size: 20,
              color: alertColor,
            ),
          ),
          SizedBox(width: 3.w),

          // Alert content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: alertColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (budgetName.isNotEmpty && amount > 0) ...[
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        budgetName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' • \$${amount.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: alertColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Dismiss button
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: EdgeInsets.all(1.w),
                child: CustomIconWidget(
                  iconName: 'close',
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
