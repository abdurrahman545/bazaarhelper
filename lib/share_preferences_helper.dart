import 'dart:convert';
import 'package:bazaarhelper_final/model/expences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _kExpensesKey = 'expenses';

  // Save an expense
  static Future<void> saveExpense(Expense expense) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson = prefs.getStringList(_kExpensesKey) ?? [];
    expensesJson.add(jsonEncode(expense.toJson())); // Convert expense to JSON string
    await prefs.setStringList(_kExpensesKey, expensesJson);
  }

  // Retrieve all expenses
  static Future<List<Expense>> getExpenses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson = prefs.getStringList(_kExpensesKey) ?? [];
    return expensesJson
        .map((String expenseJson) => Expense.fromJson(jsonDecode(expenseJson)))
        .toList();
  }

  // Update an expense
  static Future<void> updateExpense(Expense oldExpense, Expense updatedExpense) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson = prefs.getStringList(_kExpensesKey) ?? [];

    final String oldExpenseJson = jsonEncode(oldExpense.toJson());
    final String updatedExpenseJson = jsonEncode(updatedExpense.toJson());

    final int index = expensesJson.indexOf(oldExpenseJson);
    if (index != -1) {
      expensesJson[index] = updatedExpenseJson;
      await prefs.setStringList(_kExpensesKey, expensesJson);
    }
  }

  // Delete an expense
  static Future<void> deleteExpense(Expense expense) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson = prefs.getStringList(_kExpensesKey) ?? [];

    final String expenseJson = jsonEncode(expense.toJson());
    expensesJson.removeWhere((String item) => item == expenseJson);

    await prefs.setStringList(_kExpensesKey, expensesJson);
  }
}
