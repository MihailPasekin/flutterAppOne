import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/tradingqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/orderforserver.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentTypeSelector extends StatelessWidget {
  final OrderForServer orderForServerSelector;

  const PaymentTypeSelector({super.key, required this.orderForServerSelector});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar:
              AppBar(title: Text(AppLocalizations.of(context)!.paymentOption)),
          body: SingleChildScrollView(
            child: ControllerArea(orderForSerSel: orderForServerSelector),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              String orderforserverJson = jsonEncode(orderForServerSelector);
              var orderQueue = OrderQueue(
                  api: '/api/Order/createorder',
                  body: orderforserverJson,
                  createdDateTime: DateTime.now(),
                  sent: false,
                  sentDateTime: DateTime.now());
              await createOrderQueue(orderQueue);
              if (!context.mounted) return;
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.orderAddedToQueue),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SendQueueProgress())),
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                ),
              );
            },
            label: Text(AppLocalizations.of(context)!.addOrderToQueue),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          ),
        ));
  }
}

enum SingingCharacter {
  cashpaymend,
  cardpayment,
  credit5,
  credit10,
  credit15,
  credit16,
  credit20
}

class ControllerArea extends StatefulWidget {
  const ControllerArea({super.key, required this.orderForSerSel});
  final OrderForServer orderForSerSel;
  final String orderComment = '';
  @override
  State<ControllerArea> createState() => _ControllerAreaState();
}

class _ControllerAreaState extends State<ControllerArea> {
  SingingCharacter? _character = SingingCharacter.cashpaymend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context)!.cashPayment),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.cashpaymend,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                widget.orderForSerSel.GroupNum = -1;
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.enumeration),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.cardpayment,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                widget.orderForSerSel.GroupNum = 5;
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.sevenCredit),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.credit5,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                widget.orderForSerSel.GroupNum = 2;
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.fourteenCredit),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.credit10,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                widget.orderForSerSel.GroupNum = 3;
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.thirtyCredit),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.credit15,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                widget.orderForSerSel.GroupNum = 4;
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.realization),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.credit16,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                widget.orderForSerSel.GroupNum = 7;
                _character = value;
              });
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(AppLocalizations.of(context)!.comment,
            style: const TextStyle(fontSize: 14)),
        Flexible(
          child: TextFormField(
              keyboardType: TextInputType.text,
              maxLines: 6,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.comment,
                  hintText: '____'),
              onChanged: (val) {
                widget.orderForSerSel.Comment = val;
              }),
        )
      ],
    );
  }
}
