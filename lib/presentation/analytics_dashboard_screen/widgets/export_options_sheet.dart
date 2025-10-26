import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExportOptionsSheet extends StatelessWidget {
  final VoidCallback? onExportPDF;
  final VoidCallback? onExportCSV;
  final VoidCallback? onShareChart;

  const ExportOptionsSheet({
    super.key,
    this.onExportPDF,
    this.onExportCSV,
    this.onShareChart,
  });

  static void show(
    BuildContext context, {
    VoidCallback? onExportPDF,
    VoidCallback? onExportCSV,
    VoidCallback? onShareChart,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExportOptionsSheet(
        onExportPDF: onExportPDF,
        onExportCSV: onExportCSV,
        onShareChart: onShareChart,
      ),
    );
  }

  Widget _buildExportOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconName,
    required Color iconColor,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: colorScheme.onSurfaceVariant,
        size: 16,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'file_download',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Export Analytics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              color: colorScheme.outline.withValues(alpha: 0.2),
              height: 1,
            ),

            // Export options
            _buildExportOption(
              context: context,
              title: 'Export as PDF',
              subtitle: 'Complete analytics report with all charts',
              iconName: 'picture_as_pdf',
              iconColor: const Color(0xFFC62828),
              onTap: onExportPDF,
            ),

            _buildExportOption(
              context: context,
              title: 'Export as CSV',
              subtitle: 'Raw data for spreadsheet analysis',
              iconName: 'table_chart',
              iconColor: const Color(0xFF388E3C),
              onTap: onExportCSV,
            ),

            _buildExportOption(
              context: context,
              title: 'Share Chart Image',
              subtitle: 'Share current chart as image',
              iconName: 'share',
              iconColor: const Color(0xFF1976D2),
              onTap: onShareChart,
            ),

            SizedBox(height: 2.h),

            // Cancel button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
