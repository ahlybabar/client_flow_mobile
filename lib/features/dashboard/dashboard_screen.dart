import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/metric_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/mock_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
              Positioned(right: 10, top: 10, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.danger, shape: BoxShape.circle))),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Text('Welcome back! 👋', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text("Here's what's happening with your projects.", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            // KPI Cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.45,
              children: const [
                MetricCard(label: 'Total Clients', value: '48', trend: '+12%', icon: Icons.people, color: AppColors.primary),
                MetricCard(label: 'Active Projects', value: '24', trend: '+5%', icon: Icons.folder_open, color: AppColors.success),
                MetricCard(label: 'Tasks Done', value: '156', trend: '+23%', icon: Icons.task_alt, color: AppColors.warning),
                MetricCard(label: 'Revenue', value: '\$24,500', trend: '+18%', icon: Icons.attach_money, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 24),

            // Revenue Chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Revenue', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Revenue trend over 6 months', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 5000,
                          getDrawingHorizontalLine: (v) => FlLine(color: isDark ? AppColors.darkBorder : AppColors.border, strokeWidth: 0.5)),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 5000,
                            getTitlesWidget: (v, _) => Text('\$${(v / 1000).toInt()}K', style: TextStyle(fontSize: 10, color: AppColors.textMuted)))),
                          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1,
                            getTitlesWidget: (v, _) {
                              const labels = ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
                              return Text(v.toInt() < labels.length ? labels[v.toInt()] : '', style: TextStyle(fontSize: 10, color: AppColors.textMuted));
                            })),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0, maxX: 5, minY: 15000, maxY: 27000,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [FlSpot(0, 18500), FlSpot(1, 21200), FlSpot(2, 19800), FlSpot(3, 22400), FlSpot(4, 23100), FlSpot(5, 24500)],
                            isCurved: true, color: AppColors.success, barWidth: 2.5,
                            belowBarData: BarAreaData(show: true, color: AppColors.success.withValues(alpha: 0.1)),
                            dotData: FlDotData(show: true, getDotPainter: (spot, _, __, ___) =>
                              FlDotCirclePainter(radius: 3, color: AppColors.success, strokeColor: Colors.white, strokeWidth: 1.5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Project Health
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project Health', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _healthRow('Healthy', 3, AppColors.success),
                  const SizedBox(height: 8),
                  _healthRow('At Risk', 2, AppColors.warning),
                  const SizedBox(height: 8),
                  _healthRow('Critical', 1, AppColors.danger),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recent Activities
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Activities', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...MockData.activities.take(4).map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        AvatarCircle(initials: a['user'].toString().substring(0, 2).toUpperCase(), size: 32, bgColor: AppColors.primary.withValues(alpha: 0.15)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a['event'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              Text('${a['detail']} · ${a['time']}', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _healthRow(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text('$count', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
