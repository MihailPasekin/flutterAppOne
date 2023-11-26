import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:testflutterapp/models/PlanMerch.dart';
import 'package:testflutterapp/models/itemgroup.dart';
import 'package:testflutterapp/models/photo.dart';

import 'package:testflutterapp/models/planedetailmerch.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/models/delivery.dart';
import 'package:testflutterapp/models/deliveryitem.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/merchproduct.dart';
import 'package:testflutterapp/models/merchproductgroup.dart';
import 'package:testflutterapp/models/order.dart';
import 'package:testflutterapp/models/param.dart';
import 'package:testflutterapp/models/planreport.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/models/telemetryy.dart';
import 'package:testflutterapp/sqlquerylist/sqlquerylist.dart';
import 'models/user.dart';

late Database db;

Future createShaylanDB() async {
  var databaseFactory = databaseFactoryFfi;

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    db = await databaseFactory
        //.openDatabase('D:\\ShaylanEcomersDB.db');
        // .openDatabase('D:\\Projects\\TestFlutter\\ShaylanEcomersDB.db');
        .openDatabase('D:\\StudiaProject\\ShaylanEcomersDB.db');
  } else {
    var databasesPath = await getDatabasesPath();
    final path = '$databasesPath/ShaylanEcomersDB.db';

    if (kDebugMode) {
      print(path);
      deleteDatabase(path);
    }

    db = await openDatabase(path, version: 4, onCreate: (db, version) {
      db.execute(createUserTable);
      db.execute(createQueueTable);
      db.execute(createCustomerTable);
      db.execute(createItemTable);
      db.execute(createParamTable);
      db.execute(createOrderTable);
      db.execute(createDeliveryTable);
      db.execute(createDeliveryItemTable);
      db.execute(createMerchProducktGroupTable);
      db.execute(createMrechProduckt);
      db.execute(createPlanMerchTable);
      db.execute(createPalnDetailTable);
      db.execute(createPlanReportTable);
      db.execute(createPhotoBeforeTable);
      db.execute(createPhotoAfterTable);
      db.execute(createTlemetryTable);
      db.execute(createItemGroupTable);
      return;
    });
  }
}

Future openShaylanDB() async {
  var databaseFactory = databaseFactoryFfi;

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    db = await databaseFactory
        //.openDatabase('D:\\ShaylanEcomersDB.db');
        //.openDatabase('D:\\Projects\\TestFlutter\\ShaylanEcomersDB.db');
        .openDatabase('D:\\StudiaProject\\ShaylanEcomersDB.db');
  } else {
    var databasesPath = await getDatabasesPath();
    final path = '$databasesPath/ShaylanEcomersDB.db';

    db = await openDatabase(path, version: 2);
  }
}

Future closeShaylanDB() async {
  if (db.isOpen) {
    db.close();
  }
}

Future<void> createUser(User user) async {
  if (db.isOpen) {
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removeUsers() async {
  if (db.isOpen) {
    int rowCount = await db.delete('user');
    return rowCount;
  } else {
    return -1;
  }
}

Future<User> getUser() async {
  User user = User.defaultUser();
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('user', limit: 1);
    List<User> usersDb =
        List.generate(maps.length, (index) => User.fromJson(maps[index]));
    if (usersDb.isNotEmpty) {
      user = usersDb.first;
      return user;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return user;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return user;
  }
}

void createCustomer(Batch dbBatch, Customer customer) async {
  if (db.isOpen) {
    dbBatch.insert(
      'customer',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removeAllCustomers() async {
  if (db.isOpen) {
    int rowCount = await db.delete('customer');
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removeCustomerByCardCode(String cardCode) async {
  if (db.isOpen) {
    int rowCount = await db.delete('customer', where: 'CardCode = $cardCode');
    return rowCount;
  } else {
    return -1;
  }
}

Future<Customer> getCustomerByCardCode(String cardCode) async {
  Customer customer = Customer.defaultCustomer();
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('customer',
        where: 'CardCode = ?', limit: 1, whereArgs: [cardCode]);
    List<Customer> customerDb =
        List.generate(maps.length, (index) => Customer.fromJson(maps[index]));
    if (customerDb.isNotEmpty) {
      customer = customerDb.first;
      return customer;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return customer;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return customer;
  }
}

Future<int> updateCustomerByCardCode(Customer updateCustomer) async {
  if (db.isOpen) {
    int rowCount = await db.update('customer', updateCustomer.toMap(),
        where: 'CardCode = ${updateCustomer.CardCode}');
    return rowCount;
  } else {
    return -1;
  }
}

Future<List<Customer>> getListCustomers(String cardName) async {
  List<Customer> customerList = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('customer',
        where: 'CardName like "%$cardName%"', limit: 500);
    List<Customer> customerDb =
        List.generate(maps.length, (index) => Customer.fromJson(maps[index]));
    if (customerDb.isNotEmpty) {
      customerList = customerDb;
      return customerDb;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return customerList;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return customerList;
  }
}

void createItem(Batch dbBatch, Item item) async {
  if (db.isOpen) {
    dbBatch.insert(
      'item',
      item.toMapForUpdateLocalPicture(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removeAllItems() async {
  if (db.isOpen) {
    int rowCount = await db.delete('item');
    return rowCount;
  } else {
    return -1;
  }
}

Future<Item> getItemById(int id) async {
  Item item = Item.defaultItem();
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('item', where: 'id = ?', limit: 1, whereArgs: [id]);
    List<Item> itemDb =
        List.generate(maps.length, (index) => Item.fromJson(maps[index]));
    if (itemDb.isNotEmpty) {
      item = itemDb.first;
      return item;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return item;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return item;
  }
}

Future<Item> getItemByCode(String code) async {
  Item item = Item.defaultItem();
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db
        .query('item', where: 'ItemCode = ?', limit: 1, whereArgs: [code]);
    List<Item> itemDb =
        List.generate(maps.length, (index) => Item.fromJson(maps[index]));
    if (itemDb.isNotEmpty) {
      item = itemDb.first;
      return item;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return item;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return item;
  }
}

Future<List<Item>> getListItems(String itemName) async {
  List<Item> itemList = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('item', where: 'ItemName like "%$itemName%"');
    List<Item> itemDb =
        List.generate(maps.length, (index) => Item.itemFromJsonDb(maps[index]));
    if (itemDb.isNotEmpty) {
      itemList = itemDb;
      return itemDb;
    } else {
      if (kDebugMode) {
        print('Item not found');
      }
      return itemList;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return itemList;
  }
}

Future<List<Item>> getListItemsByGroup(String itemName, int goupCod) async {
  List<Item> itemList = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('item',
        where: 'ItemName like "%$itemName%" and ItmsGrpCod = $goupCod');
    List<Item> itemDb =
        List.generate(maps.length, (index) => Item.itemFromJsonDb(maps[index]));
    if (itemDb.isNotEmpty) {
      itemList = itemDb;
      return itemDb;
    } else {
      if (kDebugMode) {
        print('Item not found');
      }
      return itemList;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return itemList;
  }
}

Future<int> updateItemById(Item item) async {
  if (db.isOpen) {
    int rowCount = await db.update('item', item.toMapForUpdateLocalPicture(),
        where: 'id = ?', whereArgs: [item.id]);
    return rowCount;
  } else {
    return -1;
  }
}

Future<void> createParam(Param param) async {
  if (db.isOpen) {
    await db.insert(
      'params',
      param.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removeAllparams() async {
  if (db.isOpen) {
    int rowCount = await db.delete('params');
    return rowCount;
  } else {
    return -1;
  }
}

Future<Param> getParamByName(String name) async {
  Param param = Param.defaultParam();
  if (db.isOpen) {
    try {
      List<Map<String, dynamic>>? maps = await db
          .query('params', where: 'paramName = ?', limit: 1, whereArgs: [name]);
      List<Param> paramDB =
          List.generate(maps.length, (index) => Param.fromMap(maps[index]));
      if (paramDB.isNotEmpty) {
        param = paramDB.first;
        return param;
      } else {
        if (kDebugMode) {
          print('Param not found');
        }
        return param;
      }
    } catch (error) {
      return param;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return param;
  }
}

Future<int> updateParamByParamName(Param updateParam) async {
  if (db.isOpen) {
    int rowCount = await db.update('params', updateParam.toMap(),
        where: 'paramName = \'${updateParam.paramName}\'');
    return rowCount;
  } else {
    return -1;
  }
}

Future<void> createOrderQueue(OrderQueue queue) async {
  if (db.isOpen) {
    List<OrderQueue> orders =
        await getQueueByApi('/api/Delivery/createinvoice');
    if (orders.isNotEmpty) {
      for (OrderQueue item in orders) {
        if (queue.body == item.body) {
          return;
        } else {
          await db.insert(
            'queue',
            queue.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } else {
      await db.insert(
        'queue',
        queue.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  } else {
    return;
  }
}

Future<int> removeAllOrderQueue() async {
  if (db.isOpen) {
    int rowCount = await db.delete('queue');
    return rowCount;
  } else {
    return -1;
  }
}

/*
Future<bool> getIdOrderQueue(int id) async {
  bool ret;
  if (db.isOpen) {
    ret = await db.query('queue' );
  }
  return false;
}
*/
Future<List<OrderQueue>> getListOrderQueue() async {
  List<OrderQueue> orderQueue = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query(
      'queue',
      where: 'sent = \'false\'',
    );
    orderQueue =
        List.generate(maps.length, (index) => OrderQueue.fromJson(maps[index]));
    if (orderQueue.isNotEmpty) {
      return orderQueue;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return orderQueue;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return orderQueue;
  }
}

Future<int> updateOrderQueue(OrderQueue orderQueue) async {
  if (db.isOpen) {
    int rowCount = await db.update('queue', orderQueue.toMap(),
        where: 'id = \'${orderQueue.id}\'');
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removeOrderQueueById(int id) async {
  if (db.isOpen) {
    int rowCount = await db.delete('queue', where: 'id = ?', whereArgs: [id]);
    if (kDebugMode) {
      print('request delited $id');
    }
    return rowCount;
  } else {
    return -1;
  }
}

Future<List<OrderQueue>> getQueueByApi(String api) async {
  List<OrderQueue> orderQueue = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('queue', where: 'sent = \'false\' and api = \'$api\'');
    orderQueue =
        List.generate(maps.length, (index) => OrderQueue.fromJson(maps[index]));
    if (orderQueue.isNotEmpty) {
      return orderQueue;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return orderQueue;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return orderQueue;
  }
}

Future<List<OrderQueue>> getQueueByApiHistory(String api) async {
  List<OrderQueue> orderQueue = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('queue', where: 'sent = \'true\' and api = \'$api\'');
    orderQueue =
        List.generate(maps.length, (index) => OrderQueue.fromJson(maps[index]));
    if (orderQueue.isNotEmpty) {
      return orderQueue;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return orderQueue;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return orderQueue;
  }
}

Future<List<OrderQueue>> getQueueBysendFlag() async {
  List<OrderQueue> orderQueue = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('queue', where: 'sent = \'false\' ');
    orderQueue =
        List.generate(maps.length, (index) => OrderQueue.fromJson(maps[index]));
    if (orderQueue.isNotEmpty) {
      return orderQueue;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return orderQueue;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return orderQueue;
  }
}

void createOrder(Batch dbBatch, Order order) {
  if (db.isOpen) {
    dbBatch.insert(
      'order',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<List<Order>> getListOrder() async {
  List<Order> order = List.empty(growable: true);
  String stime = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String etime = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: -30)));
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('order',
        where: 'docDate between "$etime" and "$stime"',
        orderBy: 'docDate desc');
    order = List.generate(
        maps.length, (index) => Order.fromJsonDatabase(maps[index]));
    if (order.isNotEmpty) {
      return order;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return order;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return order;
  }
}

Future<int> removeAllOrder() async {
  if (db.isOpen) {
    int rowCount = await db.delete('order');
    return rowCount;
  } else {
    return -1;
  }
}

Future<String> getItemLocalPictureName(String code) async {
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('item', where: 'ItemCode = "$code"', limit: 1);

    List<Item> itemDb =
        List.generate(maps.length, (index) => Item.itemFromJsonDb(maps[index]));

    if (itemDb.isNotEmpty) {
      return itemDb.first.LocalPictureName ?? "";
    } else {
      if (kDebugMode) {
        print('Item not found');
      }
      return '';
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return '';
  }
}

/*
Future<List<MerchGroupScore>> getListMerchGroup() async {
  
  List<MerchGroupScore> merchGroup = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('merchgroup');
    merchGroup = List.generate(
        maps.length, (index) => MerchGroupScore.fromJson(maps[index]));
    if (merchGroup.isNotEmpty) {
      return merchGroup;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return merchGroup;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return merchGroup;
  }

}
*/
void createDelivery(Batch dbBatch, Delivery delivery) {
  if (db.isOpen) {
    dbBatch.insert(
      'delivery',
      delivery.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<List<Delivery>> getListDelivery() async {
  List<Delivery> delivery = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('delivery');
    delivery =
        List.generate(maps.length, (index) => Delivery.fromJsonDB(maps[index]));
    if (delivery.isNotEmpty) {
      return delivery;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return delivery;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return delivery;
  }
}

Future<int> removeDelivryId(int docEntry) async {
  if (db.isOpen) {
    int rowCount = await db
        .delete('delivery', where: 'docEntry = ?', whereArgs: [docEntry]);
    if (kDebugMode) {
      print('request delited $docEntry');
    }
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removeAllDelivery() async {
  if (db.isOpen) {
    int rowCount = await db.delete('delivery');
    return rowCount;
  } else {
    return -1;
  }
}

void createDeliveryItem(Batch dbBatch, DeliveryItem deliveryItem) {
  if (db.isOpen) {
    dbBatch.insert(
      'deliveryItem',
      deliveryItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<List<DeliveryItem>> getListDeliveryItem(int docEntry) async {
  List<DeliveryItem> deliveryItem = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('deliveryItem', where: 'DocEntry = $docEntry');
    deliveryItem = List.generate(
        maps.length, (index) => DeliveryItem.fromJson(maps[index]));
    if (deliveryItem.isNotEmpty) {
      return deliveryItem;
    } else {
      if (kDebugMode) {
        print('requstOrderDB not found');
      }
      return deliveryItem;
    }
  } else {
    if (kDebugMode) {
      print('requstOrderDB conection closed');
    }
    return deliveryItem;
  }
}

Future<int> removeAllDeliveryItem() async {
  if (db.isOpen) {
    int rowCount = await db.delete('deliveryItem');
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removeDelivryQueueById(int id) async {
  if (db.isOpen) {
    if (id == 0) {
      return 0;
    }
    int rowCount =
        await db.delete('delivery', where: 'id = ?', whereArgs: [id]);
    if (kDebugMode) {
      print('request delited $id');
    }
    return rowCount;
  } else {
    return -1;
  }
}

Future<List<MerchProductGroup>> getMerchProduktGroup() async {
  List<MerchProductGroup> merchProduktGroup = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('merchProduktGroup');
    List<MerchProductGroup> merchProduktGroupDB = List.generate(
        maps.length, (index) => MerchProductGroup.fromJsonDB(maps[index]));
    if (merchProduktGroupDB.isNotEmpty) {
      merchProduktGroup = merchProduktGroupDB;
      return merchProduktGroup;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return merchProduktGroup;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return merchProduktGroup;
  }
}

void createMerchProductGroup(
    Batch dbBatch, MerchProductGroup merchProduktGroup) async {
  if (db.isOpen) {
    dbBatch.insert(
      'merchProduktGroup',
      merchProduktGroup.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removeAllMerchProduct() async {
  if (db.isOpen) {
    int rowCount = await db.delete('merchproduct');
    return rowCount;
  } else {
    return -1;
  }
}

void createMerchProduct(Batch dbBatch, MerchProduct merchProduktGroup) async {
  if (db.isOpen) {
    dbBatch.insert(
      'merchproduct',
      merchProduktGroup.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removeAllMerchProductGroup() async {
  if (db.isOpen) {
    int rowCount = await db.delete('merchProduktGroup');
    return rowCount;
  } else {
    return -1;
  }
}

Future<List<MerchProduct>> getMerchProdukt(int groupId) async {
  List<MerchProduct> merchProduktGroup = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('merchproduct',
        where: 'MerchProductGroupId == $groupId');
    List<MerchProduct> merchProduktGroupDB = List.generate(
        maps.length, (index) => MerchProduct.fromJson(maps[index]));
    if (merchProduktGroupDB.isNotEmpty) {
      merchProduktGroup = merchProduktGroupDB;
      return merchProduktGroup;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return merchProduktGroup;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return merchProduktGroup;
  }
}

Future<List<PlanMerch>> getPlanMerch(String empId) async {
  List<PlanMerch> planMerch = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('planmerch', where: 'EmpId = ?', whereArgs: [empId]);
    List<PlanMerch> palnmerchDb = List.generate(
        maps.length, (index) => PlanMerch.fromJsonDb(maps[index]));
    if (palnmerchDb.isNotEmpty) {
      planMerch = palnmerchDb;
      return planMerch;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return planMerch;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return planMerch;
  }
}

Future<int> updatePlanMerch(PlanMerch planMerch) async {
  if (db.isOpen) {
    int rowCount = await db.update('planmerch', planMerch.toMap(),
        where: 'PlanId = ?', whereArgs: [planMerch.PlanId]);
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removeAllPlanMerch() async {
  if (db.isOpen) {
    int rowCount = await db.delete('planmerch');
    return rowCount;
  } else {
    return -1;
  }
}

void createPlanMerch(Batch dbBatch, PlanMerch planMerch) async {
  if (db.isOpen) {
    dbBatch.insert(
      'planmerch',
      planMerch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<List<PlanDetail>> getPlanMerchDetail(int planId) async {
  List<PlanDetail> planMerchDetail = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps =
        await db.query('plandetail', where: 'PlanId = ?', whereArgs: [planId]);
    List<PlanDetail> detailmerchDb =
        List.generate(maps.length, (index) => PlanDetail.fromJson(maps[index]));
    if (detailmerchDb.isNotEmpty) {
      planMerchDetail = detailmerchDb;
      return planMerchDetail;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return planMerchDetail;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return planMerchDetail;
  }
}

Future<PlanDetail> getPlanMerchDetailByDetailId(
    int planId, int planDetailId) async {
  PlanDetail planMerchDetail = PlanDetail.defaultPlanDetail();
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('plandetail',
        where: 'PlanId = ? and PlanDetailId = ?',
        whereArgs: [planId, planDetailId]);
    List<PlanDetail> detailmerchDb =
        List.generate(maps.length, (index) => PlanDetail.fromJson(maps[index]));
    if (detailmerchDb.isNotEmpty) {
      planMerchDetail = detailmerchDb.first;
      return planMerchDetail;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return planMerchDetail;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return planMerchDetail;
  }
}

Future<int> updatePlanDetail(PlanDetail planDetail) async {
  if (db.isOpen) {
    int rowCount = await db.update('plandetail', planDetail.toMap(),
        where: 'PlanDetailId = ?', whereArgs: [planDetail.PlanDetailId]);
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removeAllDetailMerch() async {
  if (db.isOpen) {
    int rowCount = await db.delete('plandetail');
    return rowCount;
  } else {
    return -1;
  }
}

void createDetailMerch(Batch dbBatch, PlanDetail planDetail) async {
  if (db.isOpen) {
    dbBatch.insert(
      'plandetail',
      planDetail.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

void createPlanReport(Batch dbBatch, PlanReport planReport) async {
  if (db.isOpen) {
    dbBatch.insert(
      'planReport',
      planReport.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<List<Photo>> getPhotoBefore(int planDetailId, int planaId) async {
  List<Photo> photo = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('photoBefore',
        where: 'PlanId = ? and PlanDetailId = ?',
        whereArgs: [planaId, planDetailId]);
    List<Photo> photoDb =
        List.generate(maps.length, (index) => Photo.fromJson(maps[index]));
    if (photoDb.isNotEmpty) {
      photo = photoDb;
      return photo;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return photo;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return photo;
  }
}

Future<List<Photo>> getPhotoAfter(int planDetailId, int planaId) async {
  List<Photo> photo = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query('photoAfter',
        where: 'PlanId = ? and PlanDetailId = ?',
        whereArgs: [planaId, planDetailId]);
    List<Photo> photoDb =
        List.generate(maps.length, (index) => Photo.fromJson(maps[index]));
    if (photoDb.isNotEmpty) {
      photo = photoDb;
      return photo;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return photo;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return photo;
  }
}

Future<int> removePhotoBefore() async {
  if (db.isOpen) {
    int rowCount = await db.delete('photoBefore');
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removePhotoAfter() async {
  if (db.isOpen) {
    int rowCount = await db.delete('photoAfter');
    return rowCount;
  } else {
    return -1;
  }
}

void createBeforePhoto(Photo photo) async {
  if (db.isOpen) {
    db.insert(
      'photoBefore',
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

void createAfterPhoto(Photo photo) async {
  if (db.isOpen) {
    db.insert(
      'photoAfter',
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removePhotoBeforeId(
    int planMerchId, int planDetailId, String path) async {
  if (db.isOpen) {
    if (planDetailId == 0 || planMerchId == 0) {
      return 0;
    }
    int rowCount = await db.delete('photoBefore',
        where: 'PlanId = ? and PlanDetailId = ? and FullFileName = ?',
        whereArgs: [planMerchId, planDetailId, path]);
    if (kDebugMode) {
      print('request delited: $planDetailId $planMerchId rowCount:$rowCount');
    }
    return rowCount;
  } else {
    return -1;
  }
}

Future<int> removePhotoAfterId(
    int planMerchId, int planDetailId, String path) async {
  if (db.isOpen) {
    if (planDetailId == 0 || planMerchId == 0) {
      return 0;
    }
    int rowCount = await db.delete('photoAfter',
        where: 'PlanId = ? and PlanDetailId = ? and FullFileName = ?',
        whereArgs: [planMerchId, planDetailId, path]);
    if (kDebugMode) {
      print('request delited: $planDetailId $planMerchId rowCount:$rowCount');
    }
    return rowCount;
  } else {
    return -1;
  }
}

void createTelemetry(Telemetry telemetry) async {
  if (db.isOpen) {
    db.insert(
      'telemetryy',
      telemetry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return print("NOT");
  }
}

Future<int> removeTelemetry() async {
  if (db.isOpen) {
    int rowCount = await db.delete('telemetryy');
    return rowCount;
  } else {
    return -1;
  }
}

void createItemGroup(Batch dbBatch, ItemGroup itemgroup) async {
  if (db.isOpen) {
    dbBatch.insert(
      'itemGroup',
      itemgroup.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    return;
  }
}

Future<int> removeAllItemGroup() async {
  if (db.isOpen) {
    int rowCount = await db.delete('itemGroup');
    return rowCount;
  } else {
    return -1;
  }
}

Future<List<ItemGroup>> getAllItemGroup() async {
  List<ItemGroup> itemgroup = List.empty(growable: true);
  if (db.isOpen) {
    List<Map<String, dynamic>>? maps = await db.query(
      'itemGroup',
    );
    List<ItemGroup> photoDb =
        List.generate(maps.length, (index) => ItemGroup.fromJson(maps[index]));
    if (photoDb.isNotEmpty) {
      itemgroup = photoDb;
      return itemgroup;
    } else {
      if (kDebugMode) {
        print('User not found');
      }
      return itemgroup;
    }
  } else {
    if (kDebugMode) {
      print('Database conection closed');
    }
    return itemgroup;
  }
}
