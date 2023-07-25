import 'package:hive_flutter/adapters.dart';
part 'balance_model.g.dart';

@HiveType(typeId: 2)
class BalanceModel {

  @HiveField(0)
  double balance = 0;

  BalanceModel( this.balance);
}
