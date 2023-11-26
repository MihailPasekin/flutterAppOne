import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/itempichename.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/models/item.dart';

import 'package:testflutterapp/models/merchskuscore.dart';

import 'package:testflutterapp/pages/merchandiser/sendmerchreport.dart';
import 'package:testflutterapp/partial/drawer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MerchItemGrade extends StatelessWidget {
  final String cardName;
  final Customer customer;

  const MerchItemGrade(
      {Key? key, required this.cardName, required this.customer})
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.searchItem),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.inCardName,
                  style: const TextStyle(
                      fontSize: 25.0,
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
                  child: FutureBuilder<List<Item>>(
                    future: getListItems(filterVal),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ListTile> titleList = <ListTile>[];
                        itemList = snapshot.data!.toList();
                        List<MerchSkuScore> itemListGrade = List.generate(
                            itemList.length,
                            (index) => MerchSkuScore.forItemGrade(
                                itemList[index].ItemCode,
                                ItemGrade(itemList[index], false)));
                        for (var element in itemListGrade) {
                          titleList.add(ListTile(
                              title: Text(
                                "Code: ${element.itemGrade.item.ItemCode}; Name: ${element.itemGrade.item.ItemName};",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Price: ${element.itemGrade.item.Price} TMT; Quantity: ${element.itemGrade.item.ItemCount} sany;",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              leading: ItemPictureName(
                                wid: 25,
                                hei: 40,
                                getimageFile: getimageFile,
                                item: element.itemGrade.item,
                              ),
                              trailing: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CheckboxListTile(
                                    tristate: false,
                                    tileColor: Colors.white24,
                                    value: getInitialValue(element),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        element.itemGrade.checked =
                                            value ?? false;
                                        addMerchItemGradeListOrder(element);
                                      });
                                    },
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
                          getUser().then((value) {
                            if (value.empId > 0) {
                              customMerch.EmpID = value.empId;
                              customMerch.Created = DateTime.now().toString();
                              customMerch.CardCode = widget.customer.CardCode;
                              customMerch.Comment = "Test";

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MechSendReport(
                                          customMerch: customMerch)));
                            }
                          });
                        })
                  ],
                ),
              ])),
        ));
  }

  void addMerchItemGradeListOrder(MerchSkuScore itemGrade) {
    if (customMerch.SkuScoreList.contains(itemGrade)) {
      customMerch.SkuScoreList.remove(itemGrade);
      customMerch.SkuScoreList.add(itemGrade);
    } else {
      customMerch.SkuScoreList.add(itemGrade);
    }
  }

  File getimageFile(String path) {
    File file = File(path);
    return file;
  }

  bool getInitialValue(MerchSkuScore merchSkuScore) {
    bool result = false;
    Iterable<MerchSkuScore> merchSkuScores = customMerch.SkuScoreList.where(
        (element) =>
            element.itemGrade.item.ItemCode ==
            merchSkuScore.itemGrade.item.ItemCode);
    if (merchSkuScores.isNotEmpty) {
      if (merchSkuScores.length == 1) {
        result = merchSkuScores.single.itemGrade.checked;
      }
    }

    return result;
  }
}

class ItemGrade {
  bool checked = false;
  Item item;
  ItemGrade(this.item, this.checked);

  @override
  bool operator ==(Object other) =>
      other is ItemGrade && item.ItemCode == other.item.ItemCode;
  @override
  int get hashCode => Object.hash(item.ItemCode, item.ItemName);
}
