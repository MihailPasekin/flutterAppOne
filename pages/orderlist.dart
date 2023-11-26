import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyListingPage extends StatelessWidget {
  const MyListingPage({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ordersList),
      ),
      body: FutureBuilder<List<Order>>(
        future: getListOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error has occurred!${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return PropsList(ordersList: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PropsList extends StatelessWidget {
  const PropsList({super.key, required this.ordersList});

  final List<Order> ordersList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: ordersList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(ordersList[index].cardName.toString()),
          subtitle: Text(
              'Sum: ${ordersList[index].docTotal.toString()}; Pay type: ${ordersList[index].payType}'),
          trailing: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 60,
                minHeight: 60,
                maxWidth: 80,
                maxHeight: 80,
              ),
              child: Text(DateFormat('yyyy.MM.dd HH:mm')
                  .format(ordersList[index].docDate))),
          onTap: () {},
        );
      },
    );
  }
}
