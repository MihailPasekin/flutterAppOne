import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/models/tamerchvisit.dart';
import 'package:testflutterapp/pages/itemgalery.dart';
import 'package:testflutterapp/pages/login.dart';
import 'package:testflutterapp/pages/netoption.dart';
import 'package:testflutterapp/pages/profile.dart';
import 'package:testflutterapp/pages/searchbp.dart';
import 'package:testflutterapp/pages/send/sendpage.dart';
import 'package:testflutterapp/pages/synchprogres.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TradingAgentGrive extends StatefulWidget {
  const TradingAgentGrive({super.key});

  @override
  State<TradingAgentGrive> createState() => _TradingAgentGriveState();
}

class _TradingAgentGriveState extends State<TradingAgentGrive> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        height: 370,
        width: 370,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SendPage(),
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
                                      style: const TextStyle(fontSize: 12),
                                      AppLocalizations.of(context)!.startUpload,
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
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePage(),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.account_circle,
                                    size: 60,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(AppLocalizations.of(context)!.profile,
                                      textAlign: TextAlign.center)
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
                                getUser().then((value) => {
                                      if (value.empId == 0)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          )
                                        }
                                      else
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SynchProgress(),
                                            ),
                                          )
                                        }
                                    });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.download,
                                    size: 60,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(
                                      style: const TextStyle(
                                        fontSize: 11,
                                      ),
                                      AppLocalizations.of(context)!.synchronize,
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
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  } else {
                                    if (value.jobTitle == "Söwda wekili") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SearchBP(),
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
                                    Icons.edit_document,
                                    size: 60,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(
                                      AppLocalizations.of(context)!.createOrder,
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
                                    builder: (context) => const NetOption(),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.language,
                                    size: 60,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(AppLocalizations.of(context)!.connection,
                                      textAlign: TextAlign.center)
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
                                    builder: (context) => const ItemGallery(),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    './lib/assets/stock2.png',
                                    width: 60,
                                    height: 50,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(AppLocalizations.of(context)!.stock,
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
                                showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Log Out'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Ok"),
                                      ),
                                    ],
                                  ),
                                );
                                logout();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    './lib/assets/door.png',
                                    width: 60,
                                    height: 50,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.logOut,
                                    textAlign: TextAlign.center,
                                  ),
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
                                merchVisitGlobal =
                                    TAMerchVisit.defaultTAMerchVisit();
                                getUser().then((value) {
                                  if (value.empId == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchBP.sechbpreportTrading(
                                                    "ReportTrading")));
                                  }
                                });
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
                                      AppLocalizations.of(context)!.merchReport,
                                      textAlign: TextAlign.center)
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
                                merchVisitGlobal =
                                    TAMerchVisit.defaultTAMerchVisit();
                                getUser().then((value) {
                                  if (value.empId == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchBP.sechbpHistoryTrading(
                                                    "History")));
                                  }
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    './lib/assets/magazine.png',
                                    width: 60,
                                    height: 50,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(AppLocalizations.of(context)!.story,
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])),
          ],
        ));
  }
}

/*class BottomButton extends StatefulWidget {
  const BottomButton({super.key});

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        height: 370,
        width: 370,
        child: Expanded(
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
                          splashColor: const Color.fromARGB(24, 247, 245, 245),
                          onTap: () {},
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.send,
                                size: 60,
                                color: Colors.blueGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ])));
  }
}*/

Future logout() async {
  await removeUsers();
}
