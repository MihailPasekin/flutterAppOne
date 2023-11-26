import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/pages/merchprodutctgroup.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerManagerInformation extends StatefulWidget {
  final Customer customer;

  const CustomerManagerInformation({super.key, required this.customer});

  @override
  State<CustomerManagerInformation> createState() =>
      _CustomerManagerInformationState();
}

class _CustomerManagerInformationState
    extends State<CustomerManagerInformation> {
  final formKey = GlobalKey<FormState>();
  var numberInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp("[0-9 +]")),
  ];
  @override
  Widget build(BuildContext context) {
    //final GlobalKey<FormState> form = GlobalKey<FormState>();
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(
              title: const Text("Info menager"),
            ),
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(AppLocalizations.of(context)!.whoAreYouTalkingTo,
                        style: const TextStyle(
                          height: 0,
                          fontSize: 30,
                        ))
                  ]),
                  Container(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        initialValue: merchVisitGlobal.managerName,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.nameManager,
                            hintText: ''),
                        onChanged: (val) {
                          merchVisitGlobal.managerName = val;
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: numberInputFormatters,
                        maxLines: 1,
                        initialValue: merchVisitGlobal.managerPhone,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.phoneNumber,
                            hintText: '+99364616161'),
                        onChanged: (val) {
                          merchVisitGlobal.managerPhone = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .syntaxErrorNumber;
                          }
                          return null;
                        }),
                  ),
                  Container(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        initialValue: merchVisitGlobal.jobTitle,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.jobTitle,
                            hintText: ''),
                        onChanged: (val) {
                          merchVisitGlobal.jobTitle = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .syntaxErrorText;
                          }
                          return null;
                        }),
                  ),
                  const Expanded(flex: 20, child: Text(" ")),
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
                      ElevatedButton.icon(
                          label: Text(AppLocalizations.of(context)!.next),
                          icon: const Icon(
                            Icons.turn_right_rounded,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MerchProductGroupPage(
                                              customer: widget.customer)));
                            }
                          })
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
