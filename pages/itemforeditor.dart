import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/itempichename.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/editorderitems.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemsPage extends StatelessWidget {
  final OrderQueue orderQueueForEdit;

  const ItemsPage({Key? key, required this.orderQueueForEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage(orderQueue: orderQueueForEdit);
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  List<Item> ordersItemsList = List.empty(growable: true);
  OrderForServer orderForServerEdited = OrderForServer.defaultOrderForServer();
  final OrderQueue orderQueue;
  HomePage({
    Key? key,
    required this.orderQueue,
  }) : super(key: key) {
    ordersItemsList =
        OrderForServer.fromJson(json.decode(orderQueue.body)).OrderItems;
    orderForServerEdited =
        OrderForServer.fromJson(json.decode(orderQueue.body));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filterVal = '';
  List<Item> itemList = List.empty(growable: true);

  final Item defItem = Item.defaultItem();

  @override
  initState() {
    filterVal = '';
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      filterVal = enteredKeyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    var numberInputFormatters = [
      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
    ];

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.searchItem),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      suffixIcon: const Icon(Icons.search)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder<List<Item>>(
                    future: getListItems(filterVal),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ListTile> titleList = <ListTile>[];
                        itemList = snapshot.data!.toList();
                        for (var element in itemList) {
                          titleList.add(ListTile(
                              title: Text(
                                "Code: ${element.ItemCode}; Name: ${element.ItemName};",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Price: ${element.Price} TMT; Quantity: ${element.ItemCount} sany;",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              leading: ItemPictureName(
                                wid: 25,
                                hei: 40,
                                getimageFile: getimageFile,
                                item: element,
                              ),
                              trailing: SizedBox(
                                  width: 65,
                                  height: 60,
                                  child: TextFormField(
                                    initialValue: getInitialValue(element),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: numberInputFormatters,
                                    maxLength: 4,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val.isNotEmpty &&
                                            int.parse(val) > 0) {
                                          element.ItemForOrder = true;
                                          element.ItemCountForOrder =
                                              int.parse(val);
                                          addItemToListOrder(element);
                                        } else {
                                          element.ItemForOrder = false;
                                          element.ItemCountForOrder = 0;
                                        }
                                      });
                                    },
                                    onTap: () {},
                                  ))));
                        }
                        return ListView(
                          children: titleList,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              widget.orderForServerEdited.OrderItems = widget.ordersItemsList;
              String orderforserverJson =
                  jsonEncode(widget.orderForServerEdited);
              widget.orderQueue.body = orderforserverJson;
              updateOrderQueue(widget.orderQueue);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditOrderItems(
                    orderQueueForEdit: widget.orderQueue,
                  ),
                ),
              );
            },
            label: Text(AppLocalizations.of(context)!.next),
            icon: const Icon(Icons.save),
            backgroundColor: Colors.blueAccent,
          ),
        ));
  }

  void addItemToListOrder(Item item) {
    if (widget.ordersItemsList.contains(item)) {
      widget.ordersItemsList.remove(item);
      widget.ordersItemsList.add(item);
    } else {
      widget.ordersItemsList.add(item);
    }
  }

  File getimageFile(String path) {
    File file = File(path);
    return file;
  }

  String getInitialValue(Item item) {
    String result = '';
    Iterable<Item> items = widget.ordersItemsList
        .where((element) => element.ItemCode == item.ItemCode);
    if (items.isNotEmpty) {
      if (items.length == 1) {
        result = items.single.ItemCountForOrder.toString();
      }
    }
    return result;
  }
}
