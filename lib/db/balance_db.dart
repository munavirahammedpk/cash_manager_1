import 'package:cash_manager/db/transactin_db.dart';
import 'package:cash_manager/models/balance_model.dart';
import 'package:cash_manager/models/transaction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

const BALANCE_DB_NAME = 'balance_db';

abstract class balanceDbFns {
  Future<void> addToBalance(BalanceModel amount, double oldAmount);
  Future<void> deleteFrombalance(BalanceModel amount, double oldAmount);
  Future<void> incomeToExpense(BalanceModel amount, double oldAmount);
  Future<void> expenseToIncome(BalanceModel amount, double oldAmount);
}

class balanceDb implements balanceDbFns {
  balanceDb._internal();
  static balanceDb instance = balanceDb._internal();
  factory balanceDb() {
    return instance;
  }

  ValueNotifier<double> balanceListNotifier = ValueNotifier(0);

  @override
  Future<void> addToBalance(BalanceModel amount, double oldAmount) async {
    final _balanceDb = await Hive.openBox<BalanceModel>(BALANCE_DB_NAME);
    final _values = _balanceDb.values.toList();
    if (_values.isEmpty) {
      await _balanceDb.add(BalanceModel(amount.balance));
    } else {
      final editedbalance = _values[0].balance - oldAmount;

      final newbalance = editedbalance + amount.balance;

      await _balanceDb.putAt(0, BalanceModel(newbalance));
    }
    final _newvalues = _balanceDb.values.toList();
    balanceListNotifier.value = _newvalues[0].balance;
    balanceListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteFrombalance(BalanceModel amount, oldAmount) async {
    final _balanceDb = await Hive.openBox<BalanceModel>(BALANCE_DB_NAME);
    final _values = _balanceDb.values.toList();
    if (_values.isEmpty) {
      final _amount = 0 - amount.balance;
      await _balanceDb.add(BalanceModel(_amount));
    } else {
      final editedBalance = _values[0].balance + oldAmount;
      final newbalance = editedBalance - amount.balance;
      await _balanceDb.putAt(0, BalanceModel(newbalance));
    }
    final _newvalues = _balanceDb.values.toList();
    balanceListNotifier.value = _newvalues[0].balance;
    balanceListNotifier.notifyListeners();
  }

  Future<void> refreshbalance() async {
    final _balanceDb = await Hive.openBox<BalanceModel>(BALANCE_DB_NAME);
    final _newvalues = _balanceDb.values.toList();
    if (_newvalues.isEmpty || _newvalues == []) {
      balanceListNotifier.value = 0;
    } else {
      balanceListNotifier.value = _newvalues[0].balance;
    }
    balanceListNotifier.notifyListeners();
  }

  @override
  Future<void> expenseToIncome(BalanceModel amount, double oldAmount) async {
    final _balanceDb = await Hive.openBox<BalanceModel>(BALANCE_DB_NAME);
    final _values = _balanceDb.values.toList();
    if (_values.isEmpty) {
      await _balanceDb.add(BalanceModel(amount.balance));
    } else {
      final editedbalance = _values[0].balance + oldAmount;

      final newbalance = editedbalance + amount.balance;

      await _balanceDb.putAt(0, BalanceModel(newbalance));
    }
    final _newvalues = _balanceDb.values.toList();
    balanceListNotifier.value = _newvalues[0].balance;
    balanceListNotifier.notifyListeners();
  }

  @override
  Future<void> incomeToExpense(BalanceModel amount, double oldAmount) async {
    final _balanceDb = await Hive.openBox<BalanceModel>(BALANCE_DB_NAME);
    final _values = _balanceDb.values.toList();
    if (_values.isEmpty) {
      await _balanceDb.add(BalanceModel(amount.balance));
    } else {
      final editedbalance = _values[0].balance - oldAmount;

      final newbalance = editedbalance - amount.balance;

      await _balanceDb.putAt(0, BalanceModel(newbalance));
    }
    final _newvalues = _balanceDb.values.toList();
    balanceListNotifier.value = _newvalues[0].balance;
    balanceListNotifier.notifyListeners();
  }
}
