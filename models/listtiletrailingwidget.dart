
import 'package:flutter/material.dart';

class ListTileTrailngWidget {
  int? orderQueueId;
  bool onPressed;
  Widget? get widget {
    switch (state) {
      case 'ok':
        return const Text("OK",
            style: TextStyle(
                color: Color.fromARGB(255, 52, 126, 54),
                fontSize: 22.0,
                fontWeight: FontWeight.w600));
      case 'error':
        return const Text("Error",
            style: TextStyle(
                color: Color.fromARGB(255, 199, 91, 91),
                fontSize: 22.0,
                fontWeight: FontWeight.w600));
      case 'send':
        return const Text("Sent!",
            style: TextStyle(
                color: Color.fromARGB(255, 186, 211, 228),
                fontSize: 22.0,
                fontWeight: FontWeight.w600));
      case 'redy':
        return const Icon(Icons.send);
      default:
        return const Text("data");
    }
  }

  set widget(Widget? value) {
    widget = value;
  }

  String? state;
  ListTileTrailngWidget(this.orderQueueId, this.state, this.onPressed);
}
