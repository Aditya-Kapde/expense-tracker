import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpendingVelocityWidget extends StatelessWidget {
  final Map<String, dynamic> velocityData;

  const SpendingVelocityWidget({
    super.key,
    required this.velocityData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final double currentPace =
        (velocityData['currentPace'] as num?)?.toDouble() ?? 0.0;
    final double projectedSpend =
        (velocityData['projectedSpend'] as num?)?.toDouble() ?? 0.0;
    final double budgetLimit =
        (velocityData['budgetLimit'] as num?)?.toDouble() ?? 0.0;
    final String status = velocityData['status'] as String? ?? 'on_track';
    final String message = velocityData['message'] as String? ??
        'You\'re on track with your spending';

    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'over_budget':
        statusColor = theme.colorScheme.error;
        statusIcon = Icons.trending_up;
        break;
      case 'warning':
        statusColor = AppTheme.getWarningColor(isDark);
        statusIcon = Icons.warning_outlined;
        break;
      default:
        statusColor = AppTheme.getSuccessColor(isDark);
        statusIcon = Icons.trending_flat;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: statusIcon == Icons.trending_up
                      ? 'trending_up'
                      : statusIcon == Icons.warning_outlined
                          ? 'warning'
                          : 'trending_flat',
                  size: 20,
                  color: statusColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Velocity',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Velocity metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Current Pace',
                  '₹${currentPace.toStringAsFixed(2)}/day',
                  statusColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Projected Total',
                  '₹${projectedSpend.toStringAsFixed(2)}',
                  projectedSpend > budgetLimit
                      ? theme.colorScheme.error
                      : statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Progress indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '₹${budgetLimit.toStringAsFixed(2)} limit',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: budgetLimit > 0
                      ? (projectedSpend / budgetLimit).clamp(0.0, 1.0)
                      : 0.0,
                  backgroundColor:
                      theme.colorScheme.outline.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    projectedSpend > budgetLimit
                        ? theme.colorScheme.error
                        : statusColor,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
