import 'package:testflutterapp/models/delivery.dart';
import 'package:testflutterapp/models/deliveryitem.dart';

class DeliveryForServer {
  
  Delivery delivery;
  List<DeliveryItem> deliveryItems;

  DeliveryForServer({
    required this.delivery,
    required this.deliveryItems,
  });

  Map<String, dynamic> toJson() {
    return {
      "ODLN": delivery,
      "DeliveryItems": deliveryItems,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "delivery": delivery,
      "deliveryItems": deliveryItems,
    };
  }

  factory DeliveryForServer.defaultOrderForServer() {
    return DeliveryForServer(
        delivery: Delivery.defaultDelivery(),
        deliveryItems: List.empty(growable: true));
  }

  factory DeliveryForServer.fromJsonDelivery(Map<String, dynamic> json) {
    return DeliveryForServer(
      delivery: Delivery.fromJsonDB(json['ODLN']),
      deliveryItems: List.generate(json['DeliveryItems'].length,
          (index) => DeliveryItem.fromJson(json['DeliveryItems'][index])),
    );
  }
}
