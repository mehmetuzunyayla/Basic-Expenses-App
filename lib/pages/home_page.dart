import 'package:expenses_app/components/expense_summary.dart';
import 'package:expenses_app/components/expense_tile.dart';
import 'package:expenses_app/main.dart';
import 'package:expenses_app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //prepare data on startup
    ref.read(expenseDataProvider).preparedData(); // Using ref.read
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),
            Row(
              children: [
                //dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Dollars",
                    ),
                  ),
                ),

                //cents
                Expanded(
                  child: TextField(
                    controller: newExpenseCentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Cents",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  //delete expense
  void deleteExpense(BuildContext context, ExpenseItem expense) {
    ref.read(expenseDataProvider).deleteExpense(expense);
  }

  //save
  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty) {
      // put dollars and cents together
      String amount =
          '${newExpenseDollarController.text}.${newExpenseCentsController.text}';
      //create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      // add the new expense
      ref.read(expenseDataProvider).addNewExpense(newExpense); // Using ref.read
    }

    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final value = ref.watch(expenseDataProvider); // Using ref.watch
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 238, 238),
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (BuildContext context) =>
                      deleteExpense(context, value.getAllExpenseList()[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
