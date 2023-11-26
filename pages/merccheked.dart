import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/models/merchproductsoldstat.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/merchqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MerchCheked extends StatefulWidget {
  const MerchCheked({super.key});
  @override
  State<MerchCheked> createState() => _MerchChekedState();
}

class _MerchChekedState extends State<MerchCheked> {
  bool merchCheked = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              drawer: BuildDrawer(),
              appBar: AppBar(),
              body: Column(
                children: [
                  Container(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(AppLocalizations.of(context)!.visitEnded,
                        style: const TextStyle(
                          height: 0,
                          fontSize: 28,
                        ))
                  ]),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: merchVisitGlobal.merch == "done" ? true : false,
                    onChanged: (bool? value) {
                      setState(() {
                        merchCheked = value ?? false;
                        merchVisitGlobal.merch =
                            merchCheked ? "done" : "not done";
                      });
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 6,
                        initialValue: merchVisitGlobal.comment,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.comment,
                            hintText: ''),
                        onChanged: (val) {
                          merchVisitGlobal.comment = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .syntaxErrorText;
                          }
                          return null;
                        }),
                  ),
                  Container(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    merchVisitGlobal.productSoldStat =
                                        List.generate(
                                            merchVisitGlobal.itemList.length,
                                            (index) => MerchProductSoldStat
                                                .createFromMerchProduct(
                                                    merchVisitGlobal
                                                        .itemList[index]));
                                    var orderQueue = OrderQueue(
                                        id: 0,
                                        api: '/api/Merch/postmerchvisit',
                                        body: jsonEncode(merchVisitGlobal),
                                        createdDateTime: DateTime.now(),
                                        sent: false,
                                        sentDateTime: DateTime.now());

                                    await createOrderQueue(orderQueue);

                                    if (!context.mounted) return;
                                    if (formKey.currentState!.validate()) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .send),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MerchQueue()));
                                              },
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .yes),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(AppLocalizations.of(context)!
                                      .addToQueue))),
                        ),
                      )
                    ],
                  ),
                  const Expanded(
                    flex: 20,
                    child: Text(""),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.west),
                        label: Text(AppLocalizations.of(context)!.back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                    height: 10,
                  ))
                ],
              ),
            )));
  }
}
