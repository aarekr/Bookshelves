import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BookPieChart extends StatelessWidget {
    const BookPieChart({super.key});
    final notStartedBooks = 1;
    final readingBooks = 5;
    final completedBooks = 3;

    @override
    Widget build(BuildContext context) {
        return PieChart(
            swapAnimationDuration: const Duration(milliseconds: 750),
            swapAnimationCurve: Curves.easeInOutQuint,
            PieChartData(
                sections: [
                    PieChartSectionData(
                        title: "Completed: ${completedBooks}",
                        //value: 20,
                        color: Colors.green,
                    ),
                    PieChartSectionData(
                        title: "Not Started: ${notStartedBooks}",
                        //value: 20,
                        color: Colors.blue,
                    ),
                    PieChartSectionData(
                        title: "Reading: ${readingBooks}",
                        //value: 20,
                        color: Colors.yellow,
                    ),
                ]
            ),
        );
    }
}