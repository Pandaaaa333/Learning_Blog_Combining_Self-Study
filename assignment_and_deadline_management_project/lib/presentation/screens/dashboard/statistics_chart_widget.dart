import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/user_activity_log_statistics.dart';
import 'package:intl/intl.dart';

class StatisticsChartWidget extends StatelessWidget {
  final List<UserActivityLogStatistics> statistics;

  const StatisticsChartWidget({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    if (statistics.isEmpty) {
      return const Center(child: Text('No activity data available.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'User Activity Trend (Last 30 Days)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _calculateInterval(),
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 || value.toInt() >= statistics.length) {
                          return const SizedBox.shrink();
                        }
                        final date = statistics[value.toInt()].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (statistics.length - 1).toDouble(),
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: statistics.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.totalActions.toDouble());
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF4A7DFF),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF4A7DFF).withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateInterval() {
    if (statistics.length <= 7) return 1;
    if (statistics.length <= 14) return 2;
    return (statistics.length / 5).ceilToDouble();
  }
}
