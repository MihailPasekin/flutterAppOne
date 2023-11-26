import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/listtiletrailingwidget.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/models/planreport.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/send/sendpage.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/partial/synh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlanMerchQueue extends StatefulWidget {
  const PlanMerchQueue({super.key});

  @override
  State<PlanMerchQueue> createState() {
    return _PlanMerchQueueState();
  }
}

class _PlanMerchQueueState extends State<PlanMerchQueue> {
  _PlanMerchQueueState();

  List<ListTileTrailngWidget> dictionaryReportWidget =
      List.empty(growable: true);
  bool orderSendState = false;
  OrderForServer selectedOrderForServer =
      OrderForServer.defaultOrderForServer();
  PlanReport planReportServer = PlanReport.defaultPlanReport();
  OrderQueue orderQueueForEditor = OrderQueue.defaultOrderQueue();
  bool btPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Plan Merch')),
        drawer: BuildDrawer(),
        body: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Expanded(
                flex: 1,
                child: FutureBuilder<List<OrderQueue>>(
                    future:
                        getQueueByApi('/api/MerchPlan/postcreateplanreport'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                            children: snapshot.data!.map((orderQueue) {
                          addToDictReportWidget(orderQueue, 'redy', false);
                          planReportServer =
                              PlanReport.fromJson(json.decode(orderQueue.body));
                          return Center(
                              child: ListTile(
                            title: FutureBuilder(
                                future: getPlanMerchDetailByDetailId(
                                    planReportServer.PlanId,
                                    planReportServer.PlanDetailId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        '${AppLocalizations.of(context)!.customer} ${snapshot.data!.CardName};');
                                  }
                                  return Text(
                                      AppLocalizations.of(context)!.customer);
                                }),
                            subtitle: const Text("Trailing agent REPORT"),
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
                                                  Navigator.pop(context);
                                                },
                                                child: Text(AppLocalizations.of(
                                                        context)!
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
                                                child: Text(AppLocalizations.of(
                                                        context)!
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
                                      child: dictionaryReportWidget
                                          .where((element) =>
                                              element.orderQueueId ==
                                              orderQueue.id)
                                          .single
                                          .widget,
                                      onPressed: () {
                                        setState(() {
                                          dictionaryReportWidget
                                              .where((element) =>
                                                  element.orderQueueId ==
                                                  orderQueue.id)
                                              .single
                                              .state = 'send';
                                        });

                                        sendPlanReportRequest(
                                                orderQueue.api,
                                                orderQueue.body,
                                                planReportServer.Photos)
                                            .then((value) {
                                          setState(() {
                                            if (value == 'create') {
                                              dictionaryReportWidget
                                                  .where((element) =>
                                                      element.orderQueueId ==
                                                      orderQueue.id)
                                                  .single
                                                  .state = 'ok';
                                              orderQueue.sent = true;
                                              updateOrderQueue(orderQueue);
                                            } else {
                                              dictionaryReportWidget
                                                  .where((element) =>
                                                      element.orderQueueId ==
                                                      orderQueue.id)
                                                  .single
                                                  .state = 'error';
                                            }
                                          });
                                        });
                                      },
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
        ));
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

  void addToDictReportWidget(
      OrderQueue orderQueue, String state, bool btPressed) {
    if (dictionaryReportWidget
        .where((element) => element.orderQueueId == orderQueue.id)
        .toList()
        .isEmpty) {
      dictionaryReportWidget
          .add(ListTileTrailngWidget(orderQueue.id, state, btPressed));
    } else {
      return;
    }
  }
}
