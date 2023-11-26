import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';

import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/models/user.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/deliveryqueue.dart';

import 'package:testflutterapp/pages/send/sendqueuewidgets/tradingqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendQueueProgress extends StatelessWidget {
  const SendQueueProgress({super.key});
  Future<bool> onPop(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyApp()));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.sending)),
            body: FutureBuilder<User>(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text(snapshot.error.toString());
                  if (snapshot.hasData) {
                    switch (snapshot.data!.jobTitle) {
                      case 'Sürüji ekspeditor':
                        return const SendProgressDeliveryWidget();
                      case 'Söwda wekili':
                        return const SendProgressTradingWidget();
                      default:
                        return const CircularProgressIndicator();
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                })));
  }
}
