import 'package:hive_flutter/adapters.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 1)
enum CategoryType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

@HiveType(typeId: 0)
class TransactionModel {
  @HiveField(0)
  final String purpose;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final CategoryType category;

  @HiveField(4)
  final String id;

  @HiveField(5)
  final double oldAmount;

  @HiveField(6)
  final CategoryType oldCategory;

  TransactionModel( {
   required this.id,
    required this.purpose,
    required this.amount,
    required this.date,
    required this.category,
    required this.oldAmount,
    required this.oldCategory
    
   }) ;
}
//{
  //   id = DateTime.now().microsecondsSinceEpoch.toString();
  // }
