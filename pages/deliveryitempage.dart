import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/delivery.dart';
import 'package:testflutterapp/models/deliveryforserver.dart';
import 'package:testflutterapp/models/deliveryitem.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/deliveryqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryItemPage extends StatelessWidget {
  final Delivery delivery;

  const DeliveryItemPage({Key? key, required this.delivery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage(
      delivery: delivery,
    );
  }
}

class HomePage extends StatefulWidget {
  final Delivery delivery;
  const HomePage({Key? key, required this.delivery}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filterVal = '';
  List<DeliveryItem> itemList = List.empty(growable: true);
  List<Item> itemForOrder = List.empty(growable: true);
  //final Customer customer;
  final Item defItem = Item.defaultItem();
  // int countItem = 0;
  //final String cardName;

  //_HomePageState({required this.cardName, required this.customer});

  @override
  initState() {
    filterVal = '';
    super.initState();
  }

  // This function is called whenever the text field changes

  void _runFilter(String enteredKeyword) {
    setState(() {
      filterVal = enteredKeyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.searchItem),
            ),
            body: FutureBuilder<List<DeliveryItem>>(
              future: getListDeliveryItem(widget.delivery.docEntry),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ListTile> titleList = <ListTile>[];
                  itemList = snapshot.data!.toList();
                  for (var element in itemList) {
                    titleList.add(ListTile(
                        title: ListTile(
                      title: Text(
                        "Code: ${element.ItemCode}; Name: ${element.ItemName};",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Price: ${element.Price} TMT; Quantity: ${element.Quantity} sany;",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: IconButton(
                            icon: FutureBuilder<String>(
                                future:
                                    getItemLocalPictureName(element.ItemCode),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.file(
                                        getimageFile(snapshot.requireData));
                                  } else {
                                    return Container();
                                  }
                                }),
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(element.ItemName),
                                        content: FutureBuilder<String>(
                                            future: getItemLocalPictureName(
                                                element.ItemCode),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Image.file(getimageFile(
                                                    snapshot.requireData));
                                              } else {
                                                return Container();
                                              }
                                            }),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ));
                            },
                          )),
                    )));
                  }
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          itemList.first.DocNum.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.red,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Text(
                          widget.delivery.cardName,
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueGrey,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w400),
                        ),
                        TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.search,
                              suffixIcon: const Icon(Icons.search)),
                        ),
                        Expanded(
                            child: ListView(
                          children: titleList,
                        ))
                      ]));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                DeliveryForServer deliveryforserver = DeliveryForServer(
                    delivery: widget.delivery, deliveryItems: itemList);
                String body = jsonEncode(deliveryforserver);
                var orderQueue = OrderQueue(
                    api: '/api/Delivery/createinvoice',
                    body: body,
                    createdDateTime: DateTime.now(),
                    sent: false,
                    sentDateTime: DateTime.now());

                await createOrderQueue(orderQueue);

                removeDelivryQueueById(widget.delivery.id ?? 0);
                if (!context.mounted) return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SendQueueProgressDeliveri()));
              },
              child: const Icon(Icons.done),
            )));
  }

  void addItemToListOrder(Item item) {
    if (itemForOrder.contains(item)) {
      itemForOrder.remove(item);
      itemForOrder.add(item);
    } else {
      itemForOrder.add(item);
    }
  }

  File getimageFile(String path) {
    File file = File(path);
    return file;
  }

  String getInitialValue(Item item) {
    String result = '';
    Iterable<Item> items =
        itemForOrder.where((element) => element.ItemCode == item.ItemCode);
    if (items.isNotEmpty) {
      if (items.length == 1) {
        result = items.single.ItemCountForOrder.toString();
      }
    }
    return result;
  }
}
