import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/itempichename.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/itemforeditor.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/tradingqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditOrderItems extends StatelessWidget {
  final OrderQueue orderQueueForEdit;
  final isSelected = <bool>[false, false, false];
  EditOrderItems({super.key, required this.orderQueueForEdit});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.ordersList),
            ),
            drawer: BuildDrawer(),
            body: OrderItems(orderQueue: orderQueueForEdit),
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.west),
                  label: Text(AppLocalizations.of(context)!.backToOrders),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SendQueueProgress(),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.addItemToDrder),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemsPage(
                                orderQueueForEdit: orderQueueForEdit,
                              )),
                    );
                  },
                )
              ],
            )));
  }
}

// ignore: must_be_immutable
class OrderItems extends StatefulWidget {
  List<Item> ordersList = List.empty(growable: true);
  OrderForServer orderForServerEdited = OrderForServer.defaultOrderForServer();
  final OrderQueue orderQueue;
  OrderItems({
    Key? key,
    required this.orderQueue,
  }) : super(key: key) {
    ordersList =
        OrderForServer.fromJson(json.decode(orderQueue.body)).OrderItems;
    orderForServerEdited =
        OrderForServer.fromJson(json.decode(orderQueue.body));
  }

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  bool hover = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var numberInputFormatters = [
      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
    ];
    return Column(children: [
      Expanded(
          child: ListView.builder(
        padding: const EdgeInsets.only(top: 5),
        itemCount: widget.ordersList.length,
        itemBuilder: (context, index) {
          return Column(children: [
            ListTile(
              leading: ItemPictureName(
                wid: 25,
                hei: 40,
                getimageFile: getimageFile,
                item: widget.ordersList[index],
              ),
              dense: true,
              title: Text(
                "Name: ${widget.ordersList[index].ItemName};",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Price: ${widget.ordersList[index].Price} TMT;",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              trailing: null,
              onTap: () {},
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          )),
                      onTap: () {
                        setState(() {
                          widget.ordersList.removeAt(index);
                          widget.orderForServerEdited.OrderItems =
                              widget.ordersList;
                          String orderforserverJson =
                              jsonEncode(widget.orderForServerEdited);
                          widget.orderQueue.body = orderforserverJson;
                          updateOrderQueue(widget.orderQueue);
                        });
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(0),
                    child: SizedBox(
                        width: 60,
                        height: 30,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          initialValue:
                              getInitialValue(widget.ordersList[index]),
                          keyboardType: TextInputType.number,
                          showCursor: false,
                          inputFormatters: numberInputFormatters,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          onChanged: (val) {
                            setState(() {
                              if (val.isNotEmpty && int.parse(val) > 0) {
                                widget.ordersList[index].ItemCountForOrder =
                                    int.parse(val);
                                widget.orderForServerEdited.OrderItems =
                                    widget.ordersList;
                                String orderforserverJson =
                                    jsonEncode(widget.orderForServerEdited);
                                widget.orderQueue.body = orderforserverJson;
                                updateOrderQueue(widget.orderQueue);
                              }
                            });
                          },
                        ))),
              ],
            ),
          ]);
        },
      )),
    ]);
  }

  File getimageFile(String path) {
    File file = File(path);
    return file;
  }

  String getInitialValue(Item item) {
    String result = '';
    result = item.ItemCountForOrder.toString();
    return result;
  }
}
