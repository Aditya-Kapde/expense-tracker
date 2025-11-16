import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TrendComparisonChart extends StatefulWidget {
  final String timePeriod;

  const TrendComparisonChart({
    super.key,
    required this.timePeriod,
  });

  @override
  State<TrendComparisonChart> createState() => _TrendComparisonChartState();
}

class _TrendComparisonChartState extends State<TrendComparisonChart> {
  bool showCurrentPeriod = true;
  bool showPreviousPeriod = true;

  // Mock trend data based on time period
  List<FlSpot> _getCurrentPeriodData() {
    switch (widget.timePeriod.toLowerCase()) {
      case 'daily':
        return [
          const FlSpot(0, 50),
          const FlSpot(1, 75),
          const FlSpot(2, 45),
          const FlSpot(3, 90),
          const FlSpot(4, 65),
          const FlSpot(5, 120),
          const FlSpot(6, 85),
        ];
      case 'weekly':
        return [
          const FlSpot(0, 350),
          const FlSpot(1, 525),
          const FlSpot(2, 315),
          const FlSpot(3, 630),
          const FlSpot(4, 455),
        ];
      case 'monthly':
        return [
          const FlSpot(0, 1500),
          const FlSpot(1, 2250),
          const FlSpot(2, 1350),
          const FlSpot(3, 2700),
          const FlSpot(4, 1950),
          const FlSpot(5, 3600),
          const FlSpot(6, 2550),
          const FlSpot(7, 4200),
          const FlSpot(8, 2850),
          const FlSpot(9, 4800),
          const FlSpot(10, 3150),
          const FlSpot(11, 5400),
        ];
      case 'yearly':
        return [
          const FlSpot(0, 18000),
          const FlSpot(1, 27000),
          const FlSpot(2, 16200),
          const FlSpot(3, 32400),
          const FlSpot(4, 23400),
        ];
      default:
        return [
          const FlSpot(0, 1500),
          const FlSpot(1, 2250),
          const FlSpot(2, 1350),
          const FlSpot(3, 2700),
          const FlSpot(4, 1950),
          const FlSpot(5, 3600),
          const FlSpot(6, 2550),
          const FlSpot(7, 4200),
          const FlSpot(8, 2850),
          const FlSpot(9, 4800),
          const FlSpot(10, 3150),
          const FlSpot(11, 5400),
        ];
    }
  }

  List<FlSpot> _getPreviousPeriodData() {
    switch (widget.timePeriod.toLowerCase()) {
      case 'daily':
        return [
          const FlSpot(0, 40),
          const FlSpot(1, 60),
          const FlSpot(2, 35),
          const FlSpot(3, 70),
          const FlSpot(4, 50),
          const FlSpot(5, 95),
          const FlSpot(6, 65),
        ];
      case 'weekly':
        return [
          const FlSpot(0, 280),
          const FlSpot(1, 420),
          const FlSpot(2, 252),
          const FlSpot(3, 504),
          const FlSpot(4, 364),
        ];
      case 'monthly':
        return [
          const FlSpot(0, 1200),
          const FlSpot(1, 1800),
          const FlSpot(2, 1080),
          const FlSpot(3, 2160),
          const FlSpot(4, 1560),
          const FlSpot(5, 2880),
          const FlSpot(6, 2040),
          const FlSpot(7, 3360),
          const FlSpot(8, 2280),
          const FlSpot(9, 3840),
          const FlSpot(10, 2520),
          const FlSpot(11, 4320),
        ];
      case 'yearly':
        return [
          const FlSpot(0, 14400),
          const FlSpot(1, 21600),
          const FlSpot(2, 12960),
          const FlSpot(3, 25920),
          const FlSpot(4, 18720),
        ];
      default:
        return [
          const FlSpot(0, 1200),
          const FlSpot(1, 1800),
          const FlSpot(2, 1080),
          const FlSpot(3, 2160),
          const FlSpot(4, 1560),
          const FlSpot(5, 2880),
          const FlSpot(6, 2040),
          const FlSpot(7, 3360),
          const FlSpot(8, 2280),
          const FlSpot(9, 3840),
          const FlSpot(10, 2520),
          const FlSpot(11, 4320),
        ];
    }
  }

  String _getXAxisLabel(int index) {
    switch (widget.timePeriod.toLowerCase()) {
      case 'daily':
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return index < days.length ? days[index] : '';
      case 'weekly':
        return 'W${index + 1}';
      case 'monthly':
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return index < months.length ? months[index] : '';
      case 'yearly':
        return '${2020 + index}';
      default:
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return index < months.length ? months[index] : '';
    }
  }

  double _calculatePercentageChange() {
    final currentData = _getCurrentPeriodData();
    final previousData = _getPreviousPeriodData();

    if (currentData.isEmpty || previousData.isEmpty) return 0.0;

    final currentAvg =
        currentData.map((spot) => spot.y).reduce((a, b) => a + b) /
            currentData.length;
    final previousAvg =
        previousData.map((spot) => spot.y).reduce((a, b) => a + b) /
            previousData.length;

    if (previousAvg == 0) return 0.0;

    return ((currentAvg - previousAvg) / previousAvg) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentData = _getCurrentPeriodData();
    final previousData = _getPreviousPeriodData();
    final percentageChange = _calculatePercentageChange();
    final isPositiveChange = percentageChange >= 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Trends',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: isPositiveChange
                              ? 'trending_up'
                              : 'trending_down',
                          color: isPositiveChange
                              ? const Color(0xFFC62828)
                              : const Color(0xFF388E3C),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${isPositiveChange ? '+' : ''}${percentageChange.toStringAsFixed(1)}% vs previous ${widget.timePeriod.toLowerCase()}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isPositiveChange
                                ? const Color(0xFFC62828)
                                : const Color(0xFF388E3C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'show_chart',
                color: colorScheme.primary,
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Legend and toggles
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    setState(() => showCurrentPeriod = !showCurrentPeriod),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: showCurrentPeriod
                            ? colorScheme.primary
                            : colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Current ${widget.timePeriod}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: showCurrentPeriod
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: () =>
                    setState(() => showPreviousPeriod = !showPreviousPeriod),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: showPreviousPeriod
                            ? const Color(0xFFF57C00)
                            : colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Previous ${widget.timePeriod}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: showPreviousPeriod
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Chart
          SizedBox(
            height: 25.h,
            child: Semantics(
              label:
                  "Spending Trends Line Chart comparing current vs previous period",
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval:
                        widget.timePeriod.toLowerCase() == 'yearly'
                            ? 5000
                            : widget.timePeriod.toLowerCase() == 'monthly'
                                ? 1000
                                : widget.timePeriod.toLowerCase() == 'weekly'
                                    ? 100
                                    : 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                              _getXAxisLabel(value.toInt()),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: widget.timePeriod.toLowerCase() == 'yearly'
                            ? 10000
                            : widget.timePeriod.toLowerCase() == 'monthly'
                                ? 2000
                                : widget.timePeriod.toLowerCase() == 'weekly'
                                    ? 200
                                    : 50,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value >= 1000
                                ? '₹${(value / 1000).toStringAsFixed(0)}k'
                                : '₹${value.toInt()}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  minX: 0,
                  maxX: (currentData.length - 1).toDouble(),
                  minY: 0,
                  maxY: [
                        if (showCurrentPeriod)
                          ...currentData.map((spot) => spot.y),
                        if (showPreviousPeriod)
                          ...previousData.map((spot) => spot.y),
                      ].reduce((a, b) => a > b ? a : b) *
                      1.2,
                  lineBarsData: [
                    if (showCurrentPeriod)
                      LineChartBarData(
                        spots: currentData,
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: colorScheme.primary,
                              strokeWidth: 2,
                              strokeColor: colorScheme.surface,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.3),
                              colorScheme.primary.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    if (showPreviousPeriod)
                      LineChartBarData(
                        spots: previousData,
                        isCurved: true,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF57C00),
                            Color(0xFFFF9800),
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dashArray: [5, 5],
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: const Color(0xFFF57C00),
                              strokeWidth: 2,
                              strokeColor: colorScheme.surface,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFF57C00).withValues(alpha: 0.2),
                              const Color(0xFFF57C00).withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          return LineTooltipItem(
                            '₹${flSpot.y.toStringAsFixed(0)}',
                            theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ) ??
                                const TextStyle(),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}