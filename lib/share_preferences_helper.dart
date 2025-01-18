import 'dart:convert';
import 'package:bazaarhelper_final/model/expences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _kExpensesKey = 'expenses';

//saving expenses from an user
  static Future<void> saveExpense(Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getStringList(_kExpensesKey) ?? [];
    expensesJson.add(jsonEncode(expense.toJson())); // Convert the expense to JSON string
    await prefs.setStringList(_kExpensesKey, expensesJson);
  }

//showing the expenses
  static Future<List<Expense>> getExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getStringList(_kExpensesKey) ?? [];
    return expensesJson.map((expenseJson) {
      // Convert JSON string back to Expense object
      return Expense.fromJson(jsonDecode(expenseJson));
    }).toList();
  }

// updating the expenses
  static Future<void> updateExpense(Expense oldExpense, Expense updatedExpense) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getStringList(_kExpensesKey) ?? [];

    final oldExpenseJson = jsonEncode(oldExpense.toJson());
    final updatedExpenseJson = jsonEncode(updatedExpense.toJson());

    final index = expensesJson.indexOf(oldExpenseJson);
    if (index != -1) {
      expensesJson[index] = updatedExpenseJson;
      await prefs.setStringList(_kExpensesKey, expensesJson);
    }
  }

//deleting expense from an user
  static Future<void> deleteExpense(Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getStringList(_kExpensesKey) ?? [];

    final expenseJson = jsonEncode(expense.toJson());
    expensesJson.remove(expenseJson);

    await prefs.setStringList(_kExpensesKey, expensesJson);
  }
}
