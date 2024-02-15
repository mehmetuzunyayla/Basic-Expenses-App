import 'package:expenses_app/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  // reference our box
  final _myBox = Hive.box("expense_database");
  //write data
  void saveData(List<ExpenseItem> allExpense) {
    //lets convert ExpenseItem objects into types that can stored

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    //store in database
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data

  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      //add expenses to overall list
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
