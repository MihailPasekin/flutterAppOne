import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testflutterapp/models/PlanMerch.dart';
import 'package:testflutterapp/models/deliveryitem.dart';
import 'package:testflutterapp/models/itemgroup.dart';
import 'package:testflutterapp/models/merchproduct.dart';
import 'package:testflutterapp/models/merchproductgroup.dart';
import 'package:testflutterapp/models/order.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/connstring.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/delivery.dart';
import 'package:testflutterapp/models/photo.dart';
import 'package:testflutterapp/pages/photokaemragaller.dart';

String imageAdres = "http://192.168.2.108//sapshare/Pictures/";

late TargetPlatform? platform;

Future<bool> customerSynchronization(int empid) async {
  List<Customer> customerList = List.empty(growable: true);

  await removeAllCustomers();
  customerList = await Customer.fetchCustomer(empid);
  var dbBatch = db.batch();

  for (var customer in customerList) {
    createCustomer(dbBatch, customer);
  }
  try {
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }
  }

  return true;
}

Future<bool> itemSynchronization() async {
  await removeAllItems();

  return true;
}

Future<bool> downloadItemPicture(uid) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  var dbBatch = db.batch();
  try {
    for (Item item in (await Item.fetchItem(uid))) {
      if (item.PicturName.isNotEmpty) {
        item.LocalPictureName =
            '$dir${Platform.pathSeparator}${item.PicturName}';

        if (kDebugMode) {
          print(item.LocalPictureName);
        }
        getParamByName('root').then((param) {
          http
              .get(Uri.parse(imageAdres + item.PicturName))
              .then((request) async {
            File file = File(item.LocalPictureName!);
            await file.writeAsBytes(request.bodyBytes);
          });
        });
      }
      createItem(dbBatch, item);
    }
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return true;
}

///
Future<bool> orderSynchronization(int empId) async {
  List<Order> orderList = List.empty(growable: true);

  await removeAllOrder();
  orderList = await Order.fetchOrders(empId);
  Batch dbBatch = db.batch();
  try {
    for (var order in orderList) {
      createOrder(dbBatch, order);
    }
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return true;
}

Future<bool> deliverySynchronization(int empid) async {
  List<Delivery> deliveryList = List.empty(growable: true);

  await removeAllDelivery();
  deliveryList = await Delivery.fetchDelivery(empid);
  var dbBatch = db.batch();

  for (var delivery in deliveryList) {
    createDelivery(dbBatch, delivery);
  }
  try {
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }
  }

  return true;
}

Future<Response> sendRequest(String api, String body) async {
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final response = await http.post(Uri.http(await getIpAddressRoot(), api),
      headers: headers, body: body);
  return response;
}

Future<String> sendPlanReportRequest(
    String api, String body, List<Photo> photos) async {
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final response = await http.post(Uri.http(await getIpAddressRoot(), api),
      headers: headers, body: body);
  if (response.body == "create") {
    for (var photo in photos) {
      final photoResponse = await uploadImageHTTP(File(photo.FullFileName));
      if (photoResponse.data.toString() != 'create') {
        return photoResponse.data.toString();
      }
    }
  }

  return response.body.toString();
}

Future<Response> sendDelivery(String body) async {
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final response = await http.post(
      Uri.http(await getIpAddressRoot(), '/api/Delivery/createinvoice'),
      headers: headers,
      body: body);
  return response;
}

Future<bool> deliverySynchronizationItem(int empid) async {
  List<DeliveryItem> deliveryItemList = List.empty(growable: true);

  await removeAllDeliveryItem();
  deliveryItemList = await DeliveryItem.fetchDeliveryItemByEmpId(empid);
  var dbBatch = db.batch();

  for (var deliveryItem in deliveryItemList) {
    createDeliveryItem(dbBatch, deliveryItem);
  }
  try {
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }
  }

  return true;
}

Future<bool> merchProductSynchronizationGroup() async {
  List<MerchProductGroup> merchProduktList = List.empty(growable: true);

  await removeAllMerchProductGroup();
  merchProduktList = await MerchProductGroup.fetchMerchProductGroup();
  var dbBatch = db.batch();

  for (var element in merchProduktList) {
    createMerchProductGroup(dbBatch, element);
  }
  try {
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }
  }

  return true;
}

Future<bool> merchProductSynchronization() async {
  List<MerchProduct> merchProduktList = List.empty(growable: true);

  await removeAllMerchProduct();
  merchProduktList = await MerchProduct.fetchMerchProduct();
  var dbBatch = db.batch();

  for (var element in merchProduktList) {
    createMerchProduct(dbBatch, element);
  }
  try {
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }
  }

  return true;
}

Future<bool> planMerchSynchronization(int empid) async {
  List<PlanMerch> planMerchList = List.empty(growable: true);

  await removeAllPlanMerch();
  planMerchList = await PlanMerch.fetchPlanMerch(empid);
  var dbBatch = db.batch();

  for (var planMerch in planMerchList) {
    createPlanMerch(dbBatch, planMerch);
  }
  try {
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }
  }

  for (var planMerch in planMerchList) {
    if (planMerch.PlanDetails != null) {
      for (var planMerchDetail in planMerch.PlanDetails!) {
        createDetailMerch(dbBatch, planMerchDetail);
      }
      try {
        var result = await dbBatch.commit(continueOnError: false);
        if (kDebugMode) {
          print('SUCESS ID : COMMIT ${result.length}');
        }
      } catch (e) {
        if (kDebugMode) {
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }
      }
    }
  }
  return true;
}

Future<bool> itemGroupSynchronization() async {
  List<ItemGroup> itemGroupList = List.empty(growable: true);

  await removeAllItemGroup();
  itemGroupList = await ItemGroup.fetchItemGroup();
  var dbBatch = db.batch();

  for (var element in itemGroupList) {
    createItemGroup(dbBatch, element);
  }
  try {
    var result = await dbBatch.commit(continueOnError: false);
    if (kDebugMode) {
      print('SUCESS ID : COMMIT ${result.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }
  }

  return true;
}

Future<bool> itemGrouSynchronization() async {
  await removeAllItemGroup();

  return true;
}
