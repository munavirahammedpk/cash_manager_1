import 'package:cash_manager/db/balance_db.dart';
import 'package:cash_manager/db/transactin_db.dart';
import 'package:cash_manager/screen/screen_add_transaction.dart';
import 'package:cash_manager/screen/screen_balance.dart';
import 'package:cash_manager/screen/screen_edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.getTransaction();
    balanceDb.instance.refreshbalance();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 229, 227),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Money Manager'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: TransactionDb.instance.TransactionListNotifier,
              builder: (BuildContext context, List<TransactionModel> newList,
                  Widget? _) {
                return ListView.separated(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (BuildContext context, int index) {
                    final _values = newList[index];
                    final _date = convertedDate(_values.date);
                    return Card(
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Text(
                            _date,
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor:
                              (_values.category == CategoryType.income)
                                  ? Colors.green
                                  : Colors.red,
                        ),
                        title: Text(
                          'Rs ${_values.amount}',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        subtitle: Text(_values.purpose),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenEditTransaction(transactionModel: newList[index],)));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                )),
                            IconButton(
                              onPressed: () async {
                                await TransactionDb.instance
                                    .deteteTransactin(_values.id,
                                        _values.amount, _values.category,_values.oldAmount)
                                    .then((value) => {
                                          TransactionDb.instance
                                              .getTransaction()
                                        });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: newList.length,
                );
              },
            ),
            const ScreenFooter(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ScreenAddTransaction.routerName);
        },
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
      ),
    );
  }

  String convertedDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.last}\n${_splitedDate.first}';
  }
}
