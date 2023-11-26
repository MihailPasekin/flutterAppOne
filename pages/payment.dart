import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testflutterapp/models/invoice.dart';
import 'package:testflutterapp/pages/profile.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<SharedPreferences> prefs = SharedPreferences.getInstance();

TextEditingController paySumTextField = TextEditingController();

/*
Future<void> putProps(String body) async {
  final headers = <String, String> {
  'Content-Type': 'application/json; charset=UTF-8',
  };
 
  final response = await http.post(Uri.https(root,'/api/Invoice/createpayment'), headers: headers, body:body);
  if (kDebugMode) {
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
  }
  
}
*/
class PaymentOption extends StatelessWidget {
  final Invoice? invoice;
  const PaymentOption({super.key, this.invoice});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar:
              AppBar(title: Text(AppLocalizations.of(context)!.paymentOption)),
          body: Center(
            child: MyStatefulWidget(
              invoice: invoice,
            ),
          ),
        ));
  }
}

enum SingingCharacter { cashpaymend, cardpayment }

class MyStatefulWidget extends StatefulWidget {
  final Invoice? invoice;
  const MyStatefulWidget({super.key, required this.invoice});

  @override
  State<MyStatefulWidget> createState() {
    return _MyStatefulWidgetState(invoice: invoice);
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Invoice? invoice;

  _MyStatefulWidgetState({required this.invoice});

  SingingCharacter? paymentType = SingingCharacter.cashpaymend;

  @override
  Widget build(BuildContext context) {
    var numberInputFormatters = [
      FilteringTextInputFormatter.allow(RegExp("[0-9 .]"))
    ];
    paySumTextField.text = invoice!.DocTotal.toString();
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.searchInvoice),
            ),
            body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: paySumTextField,
                      keyboardType: TextInputType.number,
                      inputFormatters: numberInputFormatters,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.enumeration),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.cardpayment,
                        groupValue: paymentType,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            paymentType = value;
                            invoice?.GroupNum = 5;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.enumeration),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.cashpaymend,
                        groupValue: paymentType,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            paymentType = value;
                            invoice?.GroupNum = -1;
                          });
                        },
                      ),
                    ),
                  ],
                )),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (double.tryParse(paySumTextField.text) != null) {
                  invoice?.PaySum = double.parse(paySumTextField.text);
                  if (invoice!.PaySum > 0) {
                    if (kDebugMode) {
                      print(jsonEncode(invoice));
                    }
                    var orderQueue = OrderQueue(
                        id: 0,
                        api: '/api/Invoice/createpayment',
                        body: jsonEncode(invoice),
                        createdDateTime: DateTime.now(),
                        sent: false,
                        sentDateTime: DateTime.now());
                    await createOrderQueue(orderQueue);
                    /*  
              putProps(jsonEncode(invoice));
              */
                    if (!context.mounted) return;
                    showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.invoiceSent),
                        //content: const Text('AlertDialog description'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage())),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (!context.mounted) return;
                    showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!
                            .paySumMustBeGreaterThanZero),
                        //content: const Text('AlertDialog description'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              label: Text(AppLocalizations.of(context)!.sendInvoice),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
            )));
  }
}

Future saveRoot(String root) async {
  prefs.then((value) => value.setString('root', root));
  return true;
}
