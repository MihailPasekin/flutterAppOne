import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testflutterapp/dbworker.dart';

import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/itemgroup.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/pages/filtergroupbutton.dart';

import 'package:testflutterapp/pages/itemwidget.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/pages/orderpaytype.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchItem extends StatelessWidget {
  final String cardName;
  final Customer customer;

  const SearchItem({Key? key, required this.cardName, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage(
      inCardName: cardName,
      customer: customer,
    );
  }
}

class HomePage extends StatefulWidget {
  final String inCardName;
  final Customer customer;
  const HomePage({Key? key, required this.inCardName, required this.customer})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filterVal = '';
  List<Item> itemList = List.empty(growable: true);
  List<Item> itemForOrder = List.empty(growable: true);

  final Item defItem = Item.defaultItem();

  Color btColor = Colors.black;

  int groupFilter = 101;
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

  void _runGroupfilter(ItemGroup itemGroup) {
    if (this.mounted) {
      setState(() {
        print(itemGroup.ItmsGrpNam);
        groupFilter = itemGroup.ItmsGrpCod;
      });
    }
  }

  void fetchdata() async {
    var data = await getListItems("");
    if (this.mounted) {
      setState(() {
        itemList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchdata();

    List<ItemWidget> titleList = <ItemWidget>[];
    for (var element in itemList.where((element) =>
        element.ItemName.contains(filterVal) &&
        element.ItmsGrpCod == groupFilter &&
        int.parse(element.ItemCount) > 0)) {
      element.ItemCountForOrder = getInitialValue(element);
      titleList.add(ItemWidget(element, addItemToListOrder));
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: BuildDrawer(),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.searchItem),
        ),
        body: Column(
          children: [
            FutureBuilder<List<ItemGroup>>(
              future: getAllItemGroup(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> widgets = List.empty(growable: true);
                  for (var element in snapshot.data!) {
                    widgets.add(FilterGroupButton(
                        element, _runGroupfilter, groupFilter));
                  }
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widgets);
                } else if (snapshot.hasError) {
                  return Text('eror');
                }
                return const CircularProgressIndicator();
              },
            ),
            Text(
              widget.inCardName,
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
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: titleList.length,
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return titleList[index];
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.west),
                  label: Text(AppLocalizations.of(context)!.backToOrders),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.next),
                  onPressed: () {
                    OrderForServer orderForServer = OrderForServer(
                        OrderClient: widget.customer.CardCode,
                        OrderSeller: uid,
                        GroupNum: -1,
                        OrderItems: itemForOrder
                            .where((element) =>
                                element.ItemForOrder == true &&
                                element.ItemCountForOrder > 0)
                            .toList(),
                        Comment: '');
                    if (orderForServer.OrderItems.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentTypeSelector(
                            orderForServerSelector: orderForServer,
                          ),
                        ),
                      );
                    } else {
                      if (!context.mounted) return;
                      showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .theQuantityOfTheItem),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => {Navigator.of(context).pop()},
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
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

  int getInitialValue(Item item) {
    int result = 0;
    Iterable<Item> items =
        itemForOrder.where((element) => element.ItemCode == item.ItemCode);
    if (items.isNotEmpty) {
      if (items.length == 1) {
        result = items.single.ItemCountForOrder;
      }
    }
    return result;
  }
}
