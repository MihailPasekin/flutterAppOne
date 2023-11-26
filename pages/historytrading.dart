import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/historiorderitem.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryTrading extends StatelessWidget {
  final String cardCode;
  const HistoryTrading({super.key, required this.cardCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      drawer: BuildDrawer(),
      body: ListHistoryTrading(
        cardCode: cardCode,
      ),
    );
  }
}
// ignore: must_be_immutable
class ListHistoryTrading extends StatefulWidget {
  final String cardCode;
  List<OrderForServer> orderForServerList = List.empty(growable: true);
  ListHistoryTrading({super.key, required this.cardCode});

  @override
  State<ListHistoryTrading> createState() => _ListHistoryTradingState();
}

class _ListHistoryTradingState extends State<ListHistoryTrading> {
  OrderForServer selectedOrderForServer =
      OrderForServer.defaultOrderForServer();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: FutureBuilder<List<OrderQueue>>(
              future: getQueueByApiHistory('/api/Order/createorder'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  widget.orderForServerList = List.generate(
                      snapshot.data!.length,
                      (index) => OrderForServer.fromJson(
                          json.decode(snapshot.data![index].body)));
                  return ListView(
                      children: widget.orderForServerList
                          .where((element) =>
                              element.OrderClient == widget.cardCode)
                          .map((orderForServer) {
                    //children: snapshot.data!.map((orderQueue) {
                    // orderQueueForEditor = orderQueue;
                    return Center(
                        child: ListTile(
                      title: FutureBuilder(
                          future: getCustomerByCardCode(
                              (orderForServer.OrderClient)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  '${AppLocalizations.of(context)!.customer} ${snapshot.data!.CardName};');
                            }
                            return Text(AppLocalizations.of(context)!.customer);
                          }),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryOrderItem(
                                    orderForServer: orderForServer)));
                      },
                      subtitle: FutureBuilder(
                          future: getOrderSum(orderForServer.OrderItems),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  '${AppLocalizations.of(context)!.orderSum} ${snapshot.data}');
                            } else {
                              return Text(AppLocalizations.of(context)!
                                  .orderSumNotFound);
                            }
                          }),
                    ));
                  }).toList());
                }
                return Text(AppLocalizations.of(context)!.loading);
              })),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.west),
            label: Text(AppLocalizations.of(context)!.back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      Container(
        height: 10,
      )
    ]);
  }

  Future<String> getOrderSum(List<Item> items) async {
    double sum = 0;

    for (Item itemForServer in items) {
      var item = await getItemByCode(itemForServer.ItemCode);
      sum +=
          (double.tryParse(item.Price) ?? 0) * itemForServer.ItemCountForOrder;
    }

    return sum.toStringAsFixed(2);
  }
}
