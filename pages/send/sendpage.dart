import 'package:flutter/material.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/deliveryqueue.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/merchqueue.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/planmerchqueue.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/tradingqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.send),
        ),
        drawer: BuildDrawer(),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                  alignment: Alignment.topLeft,
                  height: 370,
                  width: 420,
                  child: GridView.count(
                      crossAxisCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        SizedBox.fromSize(
                          child: ClipOval(
                            child: Material(
                              color: const Color.fromARGB(24, 247, 245, 245),
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(24, 247, 245, 245),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SendQueueProgress(),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.description,
                                      size: 60,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .tradeDispatch,
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox.fromSize(
                          child: ClipOval(
                            child: Material(
                              color: const Color.fromARGB(24, 247, 245, 245),
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(24, 247, 245, 245),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MerchQueue()));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.menu_book,
                                      size: 60,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .merchReport,
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox.fromSize(
                          child: ClipOval(
                            child: Material(
                              color: const Color.fromARGB(24, 247, 245, 245),
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(24, 247, 245, 245),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SendQueueProgressDeliveri(),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.local_shipping,
                                      size: 60,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .deliveryQueue,
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox.fromSize(
                          child: ClipOval(
                            child: Material(
                              color: const Color.fromARGB(24, 247, 245, 245),
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(24, 247, 245, 245),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PlanMerchQueue()));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.assignment,
                                      size: 60,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!.merchplan,
                                        style: const TextStyle(fontSize: 15),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])))
        ]),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            width: 30,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.west),
            label: Text(AppLocalizations.of(context)!.back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            },
          ),
        ]));
  }
}
