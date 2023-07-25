import 'package:cash_manager/db/balance_db.dart';
import 'package:cash_manager/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/transactin_db.dart';

class ScreenEditTransaction extends StatelessWidget {
  ScreenEditTransaction({Key? key, required this.transactionModel})
      : super(key: key);
  TransactionModel transactionModel;
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> _isDateSelected = ValueNotifier(true);
  ValueNotifier _selectedDate = ValueNotifier('');
  DateTime? _selectedDateInDateTime;
  ValueNotifier<CategoryType> selectedCategory =
      ValueNotifier(CategoryType.income);
  var _purposeEditingController;
  var _amountEditingController;

  //final _purose=ScreenEditTransaction(transactionModel:this. transactionModel);

  @override
  Widget build(BuildContext context) {
    _purposeEditingController =
        TextEditingController(text: transactionModel.purpose);
    _amountEditingController =
        TextEditingController(text: '${transactionModel.amount}');
    _selectedDate.value = convertedDate(transactionModel.date);
    _selectedDateInDateTime = transactionModel.date;
    selectedCategory.value = transactionModel.category;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${transactionModel.purpose}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _purposeEditingController,
                  decoration: InputDecoration(
                      hintText: 'Enter Purpose of Transaction',
                      labelText: 'Purpose',
                      border: OutlineInputBorder()),
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return 'Purpose is Required';
                    }
                  },
                  onChanged: (_) {
                    _formKey.currentState!.validate();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _amountEditingController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Amount of Transaction',
                      labelText: 'Amount',
                      border: OutlineInputBorder()),
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return 'Amount is Required';
                    }
                  },
                  onChanged: (_) {
                    _formKey.currentState!.validate();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _selectedDate,
                      builder: (BuildContext ctx, dynamic newDate, Widget? _) {
                        return TextButton.icon(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(
                                Duration(days: 30),
                              ),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate == null) {
                              return;
                            } else {
                              _isDateSelected.value = true;
                              _isDateSelected.notifyListeners();
                            }
                            _selectedDateInDateTime = selectedDate;
                            _selectedDate.value = convertedDate(selectedDate);
                            _selectedDate.notifyListeners();
                          },
                          label: (_selectedDate.value == null ||
                                  _selectedDate.value == ''
                              ? Text('Select Date of Transaction')
                              : Text('${_selectedDate.value}')),
                          icon: Icon(Icons.calendar_month),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: _isDateSelected,
                      builder: (BuildContext ctx, bool newBool, Widget? _) {
                        return Visibility(
                          visible: !_isDateSelected.value,
                          child: Text(
                            '(Select a Date)',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                ValueListenableBuilder(
                  valueListenable: selectedCategory,
                  builder: (BuildContext ctx, CategoryType newType, Widget? _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: CategoryType.income,
                              groupValue: selectedCategory.value,
                              onChanged: (value) {
                                selectedCategory.value = CategoryType.income;
                                selectedCategory.notifyListeners();
                              },
                            ),
                            const Text('Income'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: CategoryType.expense,
                              groupValue: selectedCategory.value,
                              onChanged: (value) {
                                //print(newType);
                                selectedCategory.value = CategoryType.expense;
                                selectedCategory.notifyListeners();
                              },
                            ),
                            const Text('Expense')
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedDate.value == '') {
                        _isDateSelected.value = false;
                      } else {
                        _isDateSelected.value = true;
                      }

                      if (_selectedDateInDateTime == null) {
                        return;
                      }
                      editTransactions();
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Add Transaction'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertedDate(DateTime date) {
    final newdate = DateFormat.yMMMd().format(date);
    return newdate;
  }

  double parsedAmount(String amt_txt) {
    final _amount = double.parse(amt_txt);
    return _amount;
  }

  Future<void> editTransactions() async {
    if (_selectedDateInDateTime == null) {
      return;
    }
    final _amount = parsedAmount(_amountEditingController.text);
    final _details = TransactionModel(
      id: transactionModel.id,
      purpose: _purposeEditingController.text,
      amount: _amount,
      date: _selectedDateInDateTime!,
      category: selectedCategory.value,
      oldAmount: transactionModel.amount,
      oldCategory: transactionModel.category,
    );
    await TransactionDb.instance.editTransaction(_details);
    await TransactionDb.instance.getTransaction();
  }
}
