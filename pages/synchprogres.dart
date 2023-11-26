import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/style/syncprogress/styles.dart';
import '../partial/synh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SynchProgress extends StatelessWidget {
  const SynchProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar: AppBar(title: const Text('Synchronization')),
          body: SynchProgressWidget(),
        ));
  }
}

// ignore: must_be_immutable
class SynchProgressWidget extends StatefulWidget {
  SynchProgressWidget({super.key});
  bool synchStateCustomer = false;
  bool synchStateItem = false;
  bool synchStateOrder = false;
  bool sunchStateDelivery = false;
  bool synchStateDeliveryItem = false;
  bool sunchStateMerchProduktGroup = false;
  bool sunchStateMerchProdukt = false;
  bool sunchStatePlanMerch = false;
  bool synchStateItemGroup = false;
  @override
  State<SynchProgressWidget> createState() {
    return _SynchProgressWidgetState();
  }
}

class _SynchProgressWidgetState extends State<SynchProgressWidget> {
  _SynchProgressWidgetState();

  @override
  void initState() {
    getUser().then((userValue) {
      if (userValue.empId > 0) {
        customerSynchronization(userValue.empId).then((value) => setState(
              () {
                widget.synchStateCustomer = value;
              },
            ));
        orderSynchronization(userValue.empId).then((value) {
          setState(() {
            widget.synchStateOrder = value;
          });
        });
        deliverySynchronization(userValue.empId).then((value) {
          setState(() {
            widget.sunchStateDelivery = value;
          });
        });
        deliverySynchronizationItem(userValue.empId).then((value) {
          setState(() {
            widget.synchStateDeliveryItem = value;
          });
        });
        merchProductSynchronizationGroup().then((value) {
          setState(() {
            widget.sunchStateMerchProduktGroup = value;
          });
        });
        merchProductSynchronization().then((value) {
          setState(() {
            widget.sunchStateMerchProdukt = value;
          });
        });
        planMerchSynchronization(userValue.empId).then((value) => setState(
              () {
                widget.sunchStatePlanMerch = value;
              },
            ));
      }
      if (!widget.synchStateItem) {
        itemSynchronization().then((value) {
          downloadItemPicture(userValue.empId).then((value) {
            setState(() {
              widget.synchStateItem = value;
            });
          });
        });
      }
      if (!widget.synchStateItemGroup) {
        itemGrouSynchronization().then((value) {
          itemGroupSynchronization().then((value) {
            setState(() {
              widget.synchStateItemGroup = value;
            });
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 30,
      ),
      Expanded(
          flex: 8,
          child: ListView(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.customerSynchProgress,
                    style: synchStyle),
                trailing: widget.synchStateCustomer
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.itemSynchProgress,
                    style: synchStyle),
                trailing: widget.synchStateItem
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.orderSynchProgress,
                    style: synchStyle),
                trailing: widget.synchStateOrder
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.deliverySyncProgress,
                    style: synchStyle),
                trailing: widget.sunchStateDelivery
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.deliverySyncProgress,
                    style: synchStyle),
                trailing: widget.synchStateDeliveryItem
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
              ListTile(
                //planmerchsync
                title: Text(AppLocalizations.of(context)!.planmerchsync,
                    style: synchStyle),
                trailing: widget.sunchStatePlanMerch
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!
                        .merchproductgroupsynchprogress,
                    style: synchStyle),
                trailing: widget.sunchStateMerchProduktGroup
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.merchproductsynchprogress,
                    style: synchStyle),
                trailing: widget.sunchStateMerchProduktGroup
                    ? Text(AppLocalizations.of(context)!.synchComplete,
                        style: synchStyle)
                    : const CircularProgressIndicator(),
              ),
            ],
          )),
      Expanded(
          flex: 1,
          child: SizedBox(
            width: 160,
            height: 32,
            child: ElevatedButton(
              onPressed: (widget.synchStateCustomer & widget.synchStateItem)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      );
                    }
                  : null,
              child: Text(AppLocalizations.of(context)!.back),
            ),
          )),
      const Expanded(flex: 2, child: SizedBox())
    ]);
  }
}
