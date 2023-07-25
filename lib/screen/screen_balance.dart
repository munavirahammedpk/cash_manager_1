import 'package:cash_manager/db/balance_db.dart';
import 'package:flutter/material.dart';

import '../models/balance_model.dart';

class ScreenFooter extends StatelessWidget {
  const ScreenFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: balanceDb.instance.balanceListNotifier,
                builder: (BuildContext ctx, double newAmount,
                    Widget? _) {
                  return Text(
                    'Balance: $newAmount',
                    style: TextStyle(
                        fontSize: 25,
                        color:(newAmount>0?Colors.green:Colors.red),
                        fontStyle: FontStyle.italic),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
