import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum ChartType { pie, bar, line }

class ChartTypeSelector extends StatefulWidget {
  final ChartType selectedType;
  final ValueChanged<ChartType> onTypeChanged;

  const ChartTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  State<ChartTypeSelector> createState() => _ChartTypeSelectorState();
}

class _ChartTypeSelectorState extends State<ChartTypeSelector> {
  final List<Map<String, dynamic>> _chartTypes = [
    {
      'type': ChartType.pie,
      'label': 'Pie Chart',
      'icon': 'pie_chart',
      'description': 'Distribution view',
    },
    {
      'type': ChartType.bar,
      'label': 'Bar Chart',
      'icon': 'bar_chart',
      'description': 'Comparison view',
    },
    {
      'type': ChartType.line,
      'label': 'Line Chart',
      'icon': 'show_chart',
      'description': 'Trend view',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _chartTypes.map((chartType) {
            final type = chartType['type'] as ChartType;
            final isSelected = type == widget.selectedType;

            return Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: GestureDetector(
                onTap: () => widget.onTypeChanged(type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: chartType['icon'] as String,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chartType['label'] as String,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          Text(
                            chartType['description'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimary.withValues(alpha: 0.8)
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
