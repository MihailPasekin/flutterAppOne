import 'package:flutter/material.dart';
import 'package:testflutterapp/itempichename.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/pages/itemgalery.dart';

class HistoryOrderItem extends StatelessWidget {
  final OrderForServer orderForServer;
  const HistoryOrderItem({super.key, required this.orderForServer});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PropsListHistory(
        ordersList: orderForServer.OrderItems,
      ),
    );
  }
}

class PropsListHistory extends StatelessWidget {
  const PropsListHistory({super.key, required this.ordersList});

  final List<Item> ordersList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: ordersList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: ItemPictureName(
              wid: 25,
              hei: 40,
              item: ordersList[index],
              getimageFile: getimageFile),
          dense: true,
          title: Text(
            ordersList[index].ItemName,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            'Price: ${ordersList[index].Price}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
          onTap: () {},
        );
      },
    );
  }
}
