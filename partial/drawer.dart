import 'package:testflutterapp/pages/login.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/pages/netoption.dart';
import 'package:testflutterapp/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testflutterapp/pages/searchbp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testflutterapp/dbworker.dart';

String uid = '';

// ignore: must_be_immutable
class BuildDrawer extends StatelessWidget {
  SharedPreferences? prefs;

  BuildDrawer({super.key}) {
    try {
      getUser().then((user) => uid = user.empId.toString());
    } catch (e) {
      print("Возникло исключение $e");
    }
  }

  Future logout() async {
    await removeUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(),
              child: Image.asset('./lib/assets/shaylan_logo.png')),
          ListTile(
            title: Text(AppLocalizations.of(context)!.main),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.profile),
            leading: const Icon(Icons.account_box),
            onTap: () {
              if (uid == '0') {
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
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.logOut),
            leading: const Icon(Icons.logout),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.logOut),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      ),
                      child: const Text("Ok"),
                    ),
                  ],
                ),
              );
              logout();
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.createOrder),
            leading: const Icon(Icons.create_sharp),
            onTap: () {
              if (uid == '0') {
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
                    builder: (context) => const SearchBP(),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.connectionOptions),
            leading: const Icon(Icons.language),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NetOption(),
                ),
              );
            },
          ),
          /*
          ListTile(
            title: const Text('Invoice list'),
            onTap:  (){
              if(uid == '0') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchInvoice(),
                  ),
                );
              }
            },
          ),*/
        ],
      ),
    );
  }

  onClickCreateOrder() {}
}
