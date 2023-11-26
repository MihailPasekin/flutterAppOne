import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/itempichename.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testflutterapp/models/item.dart';

class ItemGallery extends StatelessWidget {
  const ItemGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar: AppBar(title: const Text('Product gallery')),
          body: const ItemGalleryWidget(),
        ));
  }
}

class ItemGalleryWidget extends StatefulWidget {
  const ItemGalleryWidget({super.key});

  @override
  State<ItemGalleryWidget> createState() {
    return _ItemGalleryWidgetState();
  }
}

class _ItemGalleryWidgetState extends State<ItemGalleryWidget> {
  String filterVal = '';
  List<Item> itemList = List.empty(growable: true);
  _ItemGalleryWidgetState();

  @override
  void initState() {
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
    return Padding(
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
                  List<Card> cardList = <Card>[];
                  itemList = snapshot.data!.toList();
                  for (var element in itemList) {
                    cardList.add(Card(
                      child: ListTile(
                        title: Text(
                          "${element.ItemName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Price: ${element.Price} TMT\nQuantity: ${element.ItemCount} sany",
                        ),
                        leading: ItemPictureName(
                          wid: 25,
                          hei: 40,
                          getimageFile: getimageFile,
                          item: element,
                        ),
                      ),
                    ));
                  }
                  return ListView(
                    children: cardList,
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
            ],
          )
        ],
      ),
    );
  }
}

File getimageFile(String path) {
  File file = File(path);
  return file;
}
