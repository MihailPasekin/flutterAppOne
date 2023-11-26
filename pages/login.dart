import 'package:flutter/material.dart';
import 'package:testflutterapp/models/connect.dart';
import 'package:flutter/services.dart';
import 'package:testflutterapp/pages/profile.dart';
import 'package:testflutterapp/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testflutterapp/partial/drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool btPressed = false;
  User users = User.defaultUser();
  final TextEditingController phone = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  Future<bool> save() async {
    if (form.currentState?.validate() == true) {
      await loginProps(users).then((value) {
        if (value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        } else {
          return value;
        }
      });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var numberInputFormatters = [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    ];
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.loginPage),
            ),
            body: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset('./lib/assets/shaylan_logo.png'),
              SingleChildScrollView(
                child: Form(
                  key: form,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 60.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: numberInputFormatters,
                            maxLength: 8,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'User ID',
                                hintText: '____'),
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                if (int.parse(val) != 0) {
                                  users.empId = int.parse(val);
                                }
                              }
                            },
                            controller: phone,
                            validator: (validator) {
                              var l = validator.toString().length;
                              if (l < 1 || l > 8)
                                return 'too short or too long';
                              return null;
                            }),
                      ),
                      SizedBox(
                        height: 50,
                        width: 250,
                        /* decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20)),*/
                        child: ElevatedButton(
                          onPressed: btPressed
                              ? null
                              : () {
                                  btPressed = true;
                                  setState(() {
                                    save().then((value) => btPressed = value);
                                  });
                                },
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 130,
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }
}
