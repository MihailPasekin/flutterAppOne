import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/models/deliveryforserver.dart';
import 'package:testflutterapp/models/deliveryitem.dart';
import 'package:testflutterapp/models/listtiletrailingwidget.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/send/sendpage.dart';
import 'package:testflutterapp/partial/synh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testflutterapp/partial/drawer.dart';

class SendQueueProgressDeliveri extends StatelessWidget {
  const SendQueueProgressDeliveri({super.key});
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
            body: const SendProgressDeliveryWidget()));
  }
}

class SendProgressDeliveryWidget extends StatefulWidget {
  const SendProgressDeliveryWidget({super.key});

  @override
  State<SendProgressDeliveryWidget> createState() {
    return _SendProgressDeliveryWidgetState();
  }
}

class _SendProgressDeliveryWidgetState
    extends State<SendProgressDeliveryWidget> {
  _SendProgressDeliveryWidgetState();
  List<ListTileTrailngWidget> dictionaryDeliveryWidget =
      List.empty(growable: true);
  bool orderSendState = false;
  DeliveryForServer selectedOrderDeliveryForServer =
      DeliveryForServer.defaultOrderForServer();
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: btPressed
                    ? null
                    : () {
                        btPressed = true;
                        Future(() {
                          getQueueBysendFlag().then((listOrderQueue) {
                            for (OrderQueue orderQueue in listOrderQueue) {
                              addToDictOrderWidget(orderQueue, 'redy', false);
                            }
                            for (OrderQueue orderQueue in listOrderQueue) {
                              setState(() {
                                dictionaryDeliveryWidget
                                    .where((element) =>
                                        element.orderQueueId == orderQueue.id)
                                    .single
                                    .state = 'send';
                              });
                              sendRequest(orderQueue.api, orderQueue.body)
                                  .then((value) {
                                setState(() {
                                  if (value.statusCode == 200 &&
                                      value.body == 'create') {
                                    dictionaryDeliveryWidget
                                        .where((element) =>
                                            element.orderQueueId ==
                                            orderQueue.id)
                                        .single
                                        .state = 'ok';
                                    orderQueue.sent = true;
                                    updateOrderQueue(orderQueue);
                                  } else {
                                    dictionaryDeliveryWidget
                                        .where((element) =>
                                            element.orderQueueId ==
                                            orderQueue.id)
                                        .single
                                        .state = 'error';
                                  }
                                });
                              });
                            }
                          });
                        });
                      },
                child: Text(AppLocalizations.of(context)!.sendAllOrders,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ))
        ]),
        const SizedBox(height: 10),
        Expanded(
            child: FutureBuilder<List<OrderQueue>>(
                future: getQueueByApi('/api/Delivery/createinvoice'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        children: snapshot.data!.map((orderQueue) {
                      addToDictOrderWidget(orderQueue, 'redy', false);
                      var trailngWidget = dictionaryDeliveryWidget
                          .where((element) =>
                              element.orderQueueId == orderQueue.id)
                          .single;
                      // orderQueueForEditor = orderQueue;
                      return Center(
                          child: ListTile(
                        title: Text(
                            '${AppLocalizations.of(context)!.customer} ${(selectedOrderDeliveryForServer = DeliveryForServer.fromJsonDelivery(json.decode(orderQueue.body))).delivery.cardName};'),
                        subtitle: FutureBuilder(
                            future: getDeliverySum(
                                DeliveryForServer.fromJsonDelivery(
                                        json.decode(orderQueue.body))
                                    .deliveryItems),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  'Delivery sum: ${snapshot.data}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text(AppLocalizations.of(context)!
                                    .orderSumNotFound);
                              }
                            }),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .no),
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
                                            dictionaryDeliveryWidget
                                                .where((element) =>
                                                    element.orderQueueId ==
                                                    orderQueue.id)
                                                .single
                                                .state = 'send';
                                          });
                                          sendRequest(orderQueue.api,
                                                  orderQueue.body)
                                              .then((value) {
                                            setState(() {
                                              if (value.statusCode == 200 &&
                                                  value.body == 'create') {
                                                    
                                                dictionaryDeliveryWidget
                                                    .where((element) =>
                                                        element.orderQueueId ==
                                                        orderQueue.id)
                                                    .single
                                                    .state = 'ok';
                                                orderQueue.sent = true;
                                                removeDelivryId(DeliveryForServer.fromJsonDelivery(
                                        json.decode(orderQueue.body)).delivery.docEntry );
                                                updateOrderQueue(orderQueue);
                                              } else {
                                                dictionaryDeliveryWidget
                                                    .where((element) =>
                                                        element.orderQueueId ==
                                                        orderQueue.id)
                                                    .single
                                                    .state = 'error';
                                              }
                                            });
                                          });
                                        },
                                  child: trailngWidget.widget,
                                )),
                          ],
                        ),
                        onTap: () {},
                        onLongPress: () {},
                      ));
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

  Future<String> getDeliverySum(List<DeliveryItem> deliveryItems) async {
    double sum = 0;

    for (DeliveryItem deliveryItemForServer in deliveryItems) {
      sum += (double.tryParse(deliveryItemForServer.Price) ?? 0) *
          deliveryItemForServer.Quantity;
    }

    return sum.toStringAsFixed(2);
  }

  void addToDictOrderWidget(
      OrderQueue orderQueue, String state, bool btPressed) {
    if (dictionaryDeliveryWidget
        .where((element) => element.orderQueueId == orderQueue.id)
        .toList()
        .isEmpty) {
      dictionaryDeliveryWidget
          .add(ListTileTrailngWidget(orderQueue.id, state, btPressed));
    } else {
      return;
    }
  }
}
