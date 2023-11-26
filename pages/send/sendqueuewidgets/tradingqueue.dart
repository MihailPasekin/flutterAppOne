import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/listtiletrailingwidget.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/models/requestresult.dart';
import 'package:testflutterapp/models/tamerchvisit.dart';
import 'package:testflutterapp/pages/editorderitems.dart';
import 'package:testflutterapp/pages/send/sendpage.dart';
import 'package:testflutterapp/partial/synh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/partial/drawer.dart';

class SendQueueProgress extends StatelessWidget {
  const SendQueueProgress({super.key});
  Future<bool> onPop(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyApp()));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.sending)),
            body: const SendProgressTradingWidget()));
  }
}

class SendProgressTradingWidget extends StatefulWidget {
  const SendProgressTradingWidget({super.key});

  @override
  State<SendProgressTradingWidget> createState() {
    return _SendProgressTradingWidgetState();
  }
}

class _SendProgressTradingWidgetState extends State<SendProgressTradingWidget> {
  _SendProgressTradingWidgetState();

  bool orderSendState = false;
  OrderForServer selectedOrderForServer =
      OrderForServer.defaultOrderForServer();
  TAMerchVisit taMerchVisitForServer = TAMerchVisit.defaultTAMerchVisit();
  OrderQueue orderQueueForEditor = OrderQueue.defaultOrderQueue();
  bool btPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const SizedBox(height: 10),
        Expanded(
            child: FutureBuilder<List<OrderQueue>>(
                future: getQueueByApi('/api/Order/createorder'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        children: snapshot.data!.map((orderQueue) {
                      addToDictOrderWidget(orderQueue, 'redy', false);
                      var trailngWidget = dictionaryOrderWidget
                          .where((element) =>
                              element.orderQueueId == orderQueue.id)
                          .single;
                      // orderQueueForEditor = orderQueue;
                      return Column(children: [
                        ListTile(
                          title: FutureBuilder(
                              future: getCustomerByCardCode(
                                  (selectedOrderForServer =
                                          OrderForServer.fromJson(
                                              json.decode(orderQueue.body)))
                                      .OrderClient),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${AppLocalizations.of(context)!.customer} ${snapshot.data!.CardName};',
                                  );
                                }
                                return Text(
                                    AppLocalizations.of(context)!.customer);
                              }),
                          subtitle: FutureBuilder(
                              future: getOrderSum(OrderForServer.fromJson(
                                      json.decode(orderQueue.body))
                                  .OrderItems),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${AppLocalizations.of(context)!.orderSum} ${snapshot.data}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return Text(AppLocalizations.of(context)!
                                      .orderSumNotFound);
                                }
                              }),
                          onTap: () {},
                          onLongPress: () {},
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(4),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditOrderItems(
                                              orderQueueForEdit: orderQueue),
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.create))),
                            Padding(
                                padding: const EdgeInsets.all(3),
                                child: ElevatedButton(
                                  child: const Icon(Icons.delete_forever),
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .deleteOrder),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .no),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                removeOrderQueueById(
                                                    orderQueue.id!);
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .yes),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(3),
                                child: ElevatedButton(
                                  onPressed: trailngWidget.onPressed
                                      ? null
                                      : () {
                                          trailngWidget.onPressed = true;
                                          setState(() {
                                            dictionaryOrderWidget
                                                .where((element) =>
                                                    element.orderQueueId ==
                                                    orderQueue.id)
                                                .single
                                                .state = 'send';
                                          });
                                          sendRequest(orderQueue.api,
                                                  orderQueue.body)
                                              .then((value) {
                                            RequestResult requestResult =
                                                RequestResult.fromJson(
                                                    json.decode(value.body));
                                            setState(() {
                                              if (value.statusCode == 200 &&
                                                  requestResult.status ==
                                                      "create") {
                                                dictionaryOrderWidget
                                                    .where((element) =>
                                                        element.orderQueueId ==
                                                        orderQueue.id)
                                                    .single
                                                    .state = 'ok';
                                                orderQueue.sent = true;
                                                updateOrderQueue(orderQueue);
                                              } else {
                                                dictionaryOrderWidget
                                                    .where((element) =>
                                                        element.orderQueueId ==
                                                        orderQueue.id)
                                                    .single
                                                    .state = 'error';
                                              }
                                            });
                                            showErrorItemsMessage(
                                                requestResult, orderQueue);
                                          });
                                        },
                                  child: trailngWidget.widget,
                                )),
                          ],
                        ),
                      ]);
                    }).toList());
                  }
                  return Text(AppLocalizations.of(context)!.loading);
                })),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.west),
                label: Text(AppLocalizations.of(context)!.back),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SendPage()));
                },
              ),
            ],
          ),
        )
      ],
    );
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

  void addToDictOrderWidget(
      OrderQueue orderQueue, String state, bool btPressed) {
    if (dictionaryOrderWidget
        .where((element) => element.orderQueueId == orderQueue.id)
        .toList()
        .isEmpty) {
      dictionaryOrderWidget
          .add(ListTileTrailngWidget(orderQueue.id, state, btPressed));
    } else {
      return;
    }
  }

  void cleanDictOrderWidget() {
    dictionaryOrderWidget.clear();
  }

  void showErrorItemsMessage(
      RequestResult requestResult, OrderQueue orderQueue) {
    if (requestResult.errorItemList != null &&
        requestResult.errorItemList!.isNotEmpty) {
      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Bu harytlar ýok!"),
                content: SizedBox(
                    width: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: requestResult.errorItemList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(requestResult
                              .errorItemList![index].ItemName
                              .toString()),
                          onTap: () {},
                        );
                      },
                    )),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        dictionaryOrderWidget
                            .where((element) =>
                                element.orderQueueId == orderQueue.id)
                            .single
                            .state = 'ok';
                        orderQueue.sent = true;
                        updateOrderQueue(orderQueue);
                      });
                      /*  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SendQueueProgress(),
                        ),
                      );*/
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
  }
}
