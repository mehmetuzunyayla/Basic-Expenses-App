import 'package:expenses_app/bar%20graph/bar_graph.dart';
import 'package:expenses_app/data/expense_data.dart';
import 'package:expenses_app/datetime/date_time_helper.dart';
import 'package:expenses_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseSummary extends ConsumerWidget {
  // Changed to ConsumerWidget
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });

  double calculateMax(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double? max = 100;
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];
    values.sort();
    max = values.last * 1.1;
    return max == 0 ? 100 : max;
  }

  String calculateWeekTotal(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];
    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

  String calculateTodayTotal(ExpenseData value) {
    String today =
        convertDateTimeToString(DateTime.now()); // Format today's date
    double todayTotal = value.calculateDailyExpenseSummary()[today] ?? 0;
    return todayTotal.toStringAsFixed(
        2); // Convert the total to a string with 2 decimal places
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref parameter
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    final value = ref.watch(expenseDataProvider); // Using ref.watch

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
            height: 20), // You can adjust this value to fit your needs
        Padding(
          padding:
              const EdgeInsets.fromLTRB(25.0, 0, 25.0, 8.0), // Add top padding
          child: Text(
            "Week Total: \$${calculateWeekTotal(value, monday, tuesday, wednesday, thursday, friday, saturday, sunday)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 8.0),
          child: Text(
            "Today's expenses: \$${calculateTodayTotal(value)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: MyBarGraph(
            maxY: calculateMax(value, sunday, monday, tuesday, wednesday,
                thursday, friday, saturday),
            sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
            monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
            tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
            wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
            thurAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
            friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
            satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
          ),
        ),
      ],
    );
  }
}
