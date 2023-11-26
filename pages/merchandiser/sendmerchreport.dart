import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/models/custommerch.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/partial/synh.dart';

class MechSendReport extends StatefulWidget {
  final CustomMerch customMerch;
  const MechSendReport({super.key, required this.customMerch});

  @override
  State<MechSendReport> createState() => _MechSendReportState();
}

class _MechSendReportState extends State<MechSendReport> {
  String status = 'send report';
  var i = " ";
  String api = "/api/Merch/putcostommerch";
  bool btPressed = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(),
            body: Column(children: [
              Container(
                height: 200,
              ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: btPressed
                      ? null
                      : () {
                          btPressed = true;
                          String body = jsonEncode(customMerch);
                          setState(() {
                            status = "send";
                          });
                          sendRequest(api, body).then((value) {
                            setState(() {
                              if (value.statusCode == 200 && value.body == 'create')  {
                                status = 'send report';
                                showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Report sent'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ],
                                  ),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()));
                              } else {
                                status = 'error';
                              }
                            });
                          });
                        },
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ])));
  }
}
