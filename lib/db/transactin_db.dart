import 'package:cash_manager/db/balance_db.dart';
import 'package:cash_manager/models/transaction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/balance_model.dart';

const TRANSACTION_DB_NAME = 'transaction_db';

abstract class TransactionDbFns {
  Future<void> addTransaction(TransactionModel details);
  Future<void> getTransaction();
  Future<void> deteteTransactin(
      String id, double amount, CategoryType type, double oldAmount);
  Future<void> editTransaction(TransactionModel details);
}

class TransactionDb implements TransactionDbFns {
  TransactionDb.internal();
  static TransactionDb instance = TransactionDb.internal();
  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> TransactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(details) async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    final _amount = BalanceModel(details.amount);
    if (details.category == CategoryType.income) {
      await balanceDb.instance.addToBalance(_amount, details.oldAmount);
    } else {
      await balanceDb.instance.deleteFrombalance(_amount, details.oldAmount);
    }

    _transactionDb.put(details.id, details);
  }

  @override
  Future<void> getTransaction() async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    final _details = _transactionDb.values.toList();
    _details.sort((first, second) => second.date.compareTo(first.date));
    TransactionListNotifier.value.clear();
    TransactionListNotifier.value.addAll(_details);
    TransactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deteteTransactin(id, amount, type, oldAmount) async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    final _amount = BalanceModel(amount);
    oldAmount=0;
    if (type == CategoryType.income) {
      await balanceDb.instance.deleteFrombalance(_amount, oldAmount);
    } else {
      await balanceDb.instance.addToBalance(_amount, oldAmount);
    }
    await _transactionDb.delete(id);
  }

  @override
  Future<void> editTransaction(TransactionModel details) async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    final _amount = BalanceModel(details.amount);
    if (details.category == CategoryType.income) {
      if (details.oldCategory == CategoryType.income) {
        await balanceDb.instance.addToBalance(_amount, details.oldAmount);
      } else {
        balanceDb.instance.expenseToIncome(_amount, details.oldAmount);
      }
    } else {
      if (details.oldCategory == CategoryType.expense) {
        await balanceDb.instance.deleteFrombalance(_amount, details.oldAmount);
      } else {
        balanceDb.instance.incomeToExpense(_amount, details.oldAmount);
      }
    }
    _transactionDb.put(details.id, details);
  }
}
