
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_tracker/cubit/cubit/fetchdata_cubit.dart';
import 'package:sleep_tracker/cubit/cubit/fetchdata_state.dart';
import 'package:sleep_tracker/local_storage.dart';

class MyBarChart extends StatelessWidget {
  MyBarChart({super.key});

  final localStorage = LocalStorage();

  // Future<List<BarChartGroupData>> _generateBarGroups() async {
  //   final data = localStorage.getAllValues();

  // //   return data.asMap().entries.map((entry) {
  // //     final index = entry.key;
  // //     final item = entry.value;
  // //       print(item["duration"]);
  // //     return BarChartGroupData(
  // //       x: index,
  // //       barRods: [
  // //         BarChartRodData(
  // //           toY: (item['duration'] as num).toDouble(),
  // //           color: const Color(0xFF4682B4), // Steel Blue color for bars
  // //           width: 20, // Wider bars
  // //           borderRadius: BorderRadius.circular(4),
  // //         )
  // //       ],
  // //       showingTooltipIndicators: [0],

  // //     );
  // //   }).toList();
  // // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchdataCubit, FetchdataState>(
      builder: (context, state) {
        if (state is FetchdataLoading) {
          return const CircularProgressIndicator();
        } else if (state is Fetchdatafailed) {
          return const Text("error has happened");
        } else if (state is Fetchdatasuccess) {
          List<BarChartGroupData> barchartgroupData =
              state.data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (item['duration'] as num).toDouble(),
                  color: const Color(0xFF4682B4), // Steel Blue color for bars
                  width: 20, // Wider bars
                  borderRadius: BorderRadius.circular(4),
                
                )
              ],
              showingTooltipIndicators: [0],
            );
          }).toList();
          return Container(
            margin: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 4 / 3, // Larger aspect ratio
              child: BarChart(
                BarChartData(
                  maxY: 24,
                  groupsSpace: 15,
                  titlesData: _titlesData,
                  barGroups: barchartgroupData,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          );
        } else {
          return const Text("somehting unexpected happened");
        }
      },
    );
  }
}

FlTitlesData get _titlesData => const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: _getTitles,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

Widget _getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  const days = ['Sn', 'Mn', 'Tu', 'Wd', 'Tr', 'Fr', 'St'];
  final index = value.toInt();

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(days[index % days.length], style: style),
  );
}
