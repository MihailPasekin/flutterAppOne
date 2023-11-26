import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/pages/castomerdelivery.dart';
import 'package:testflutterapp/pages/login.dart';
import 'package:testflutterapp/pages/searchbp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MerchandaiserGrivew extends StatefulWidget {
  const MerchandaiserGrivew({super.key});

  @override
  State<MerchandaiserGrivew> createState() => _MerchandaiserGrivewState();
}

class _MerchandaiserGrivewState extends State<MerchandaiserGrivew> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 23,
          alignment: Alignment.bottomLeft,
          color: const Color.fromARGB(24, 247, 245, 245),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.merchandiserAndDelivery,
                selectionColor: Colors.black,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )
            ],
          ),
        ),
        Container(height: 2, color: Colors.black),
        Container(
            alignment: Alignment.topLeft,
            height: 120,
            width: 380,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 2,
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
                                  getUser().then((value) {
                                    if (value.empId == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchBP.serchbpMerch("merch"),
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      './lib/assets/pord.png',
                                      width: 65,
                                      height: 61,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(AppLocalizations.of(context)!.merch,
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
                                  getUser().then((value) {
                                    if (value.empId == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    } else {
                                      if (value.jobTitle ==
                                          "Sürüji ekspeditor") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CastomerDelivery(user: value),
                                          ),
                                        );
                                      }
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.local_shipping,
                                      size: 60,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(AppLocalizations.of(context)!.delivery,
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
                                  /*
                                  getUser().then((value) {
                                    if (value.empId == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ));
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PlanPageMerch(),
                                        ),
                                      );
                                    }
                                  });*/
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
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
            ])),
      ],
    );
  }
}
