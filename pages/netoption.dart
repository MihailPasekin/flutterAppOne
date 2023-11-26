import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/models/connstring.dart';
import 'package:testflutterapp/models/param.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NetOption extends StatelessWidget {
  const NetOption({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.connectionOptions)),
          body: const Center(
            child: MyStatefulWidget(),
          ),
        ));
  }
}

enum SingingCharacter { wificonnection, internetconnection }

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  SingingCharacter? _character;
  String address = "";
  final ipTextFieldController = TextEditingController();
  @override
  void initState() {
    getIpAddressRoot().then((ip) {
      if (ip.isNotEmpty) {
        setState(() {
          ipTextFieldController.text = ip;
          address = ip;
          if (ip == "192.168.2.65:5093") {
            _character = SingingCharacter.wificonnection;
          }
          if (ip == "95.85.112.154:5093") {
            _character = SingingCharacter.internetconnection;
          }
        });
      }
    });

    super.initState();
  }

  void changeIpAddress(String newAddress) {
    setState(() {
      address = newAddress;
      ipTextFieldController.text = newAddress;
      saveRoot(address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getIpAddressRoot(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error has occurred!${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context)!.connectionWiFi),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.wificonnection,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      _character = value;
                      changeIpAddress("192.168.2.65:5093");
                    },
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.blueGrey,
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.internetConnection),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.internetconnection,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      _character = value;
                      changeIpAddress("95.85.112.154:5093");
                    },
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.blueGrey,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: ipTextFieldController,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                          onPressed: () {
                            changeIpAddress(ipTextFieldController.text);
                            if (!context.mounted) return;
                            print(address);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyApp(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: const TextStyle(fontSize: 15),
                          )))
                ]),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Future saveRoot(String root) async {
  await updateParamByParamName(Param('root', 0, '', root));
  return true;
}
