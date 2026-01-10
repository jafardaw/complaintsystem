// lib/pages/stats_page.dart
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/Report/data/statistics_model.dart';
import 'package:compaintsystem/featuer/Report/presentation/view/manager/get_cubit/get_statistics_cubit.dart';
import 'package:compaintsystem/featuer/Report/presentation/view/manager/get_cubit/get_statistics_state.dart';
import 'package:compaintsystem/featuer/Report/repo/repo_statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatsCubit(StatsRepository(ApiService()))..loadStats(),
      child: const _StatsView(),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إحصائيات الشكاوى'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<StatsCubit>().refreshStats(),
          ),
        ],
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('خطأ: ${state.message}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<StatsCubit>().loadStats(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is StatsLoaded) {
            final stats = state.stats;
            return _buildStatsView(context, stats);
          }

          return const Center(child: Text('قم بتحميل البيانات'));
        },
      ),
    );
  }

  Widget _buildStatsView(BuildContext context, ComplaintStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // البطاقة الرئيسية للإحصائيات
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'نظرة عامة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'إجمالي الشكاوى',
                        '${stats.totalComplaints}',
                      ),
                      _buildStatCard('تم الحل', '${stats.resolvedCount}'),
                      _buildStatCard(
                        'معدل الحل',
                        '${stats.resolutionRate.toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // رسم بياني دائري للحالة مع مفتاح الألوان
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'توزيع الشكاوى حسب الحالة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: _buildStatusSections(stats.byStatus),
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  // مفتاح الألوان للحالة
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailedLegendItem(
                          Colors.blue,
                          'جديد',
                          '${stats.byStatus.newCount} شكوى',
                        ),
                        _buildDetailedLegendItem(
                          Colors.orange,
                          'قيد المعالجة',
                          '${stats.byStatus.inProgress} شكوى',
                        ),
                        _buildDetailedLegendItem(
                          Colors.red,
                          'مرفوض',
                          '${stats.byStatus.rejected} شكوى',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // رسم بياني عمودي للأولوية مع مفتاح الألوان
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'توزيع الشكاوى حسب الأولوية',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (stats.byPriority.high + stats.byPriority.medium)
                            .toDouble(),
                        barGroups: _buildPriorityGroups(stats.byPriority),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(value == 0 ? 'عالي' : 'متوسط');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // مفتاح الألوان للأولوية
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailedLegendItem(
                          Colors.red,
                          'أولوية عالية',
                          '${stats.byPriority.high} شكوى',
                        ),
                        _buildDetailedLegendItem(
                          Colors.amber,
                          'أولوية متوسطة',
                          '${stats.byPriority.medium} شكوى',
                        ),
                        _buildDetailedLegendItem(
                          const Color.fromARGB(255, 7, 123, 255),
                          'أولوية منخفضة',
                          '${stats.byPriority.low} شكوى',
                        ),
                      ],
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

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  List<PieChartSectionData> _buildStatusSections(StatusDistribution status) {
    final colors = [Colors.blue, Colors.orange, Colors.red];
    // final labels = ['جديد', 'قيد المعالجة', 'مرفوض'];
    final values = [status.newCount, status.inProgress, status.rejected];

    return List.generate(3, (i) {
      final value = values[i].toDouble();
      return PieChartSectionData(
        color: colors[i],
        value: value,
        title: '${value.toInt()}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  List<BarChartGroupData> _buildPriorityGroups(PriorityDistribution priority) {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: priority.high.toDouble(),
            color: Colors.red,
            width: 30,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: priority.medium.toDouble(),
            color: Colors.amber,
            width: 30,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: priority.low.toDouble(),
            color: const Color.fromARGB(255, 7, 123, 255),
            width: 30,
          ),
        ],
      ),
    ];
  }

  Widget _buildDetailedLegendItem(Color color, String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black12, width: 1),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}
