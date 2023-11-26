import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testflutterapp/globalvariables.dart';

import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/partial/merchandisergrivet.dart';
import 'package:testflutterapp/partial/tradingagentgritview.dart';
import 'dbworker.dart';
import 'models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/enums/charging_status.dart';

const List<String> list = <String>['EN', 'TM', 'RU'];
Locale locale = const Locale('tr', '');
String dropdownValue = list.firstWhere((element) => element == 'TM');

Future<void> main() async {
  HttpOverrides.global = MyHttpoverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await createShaylanDB();
  try {
    cameraDescriptionList = await availableCameras();
  } on CameraException catch (e) {
    print(e.description);
  }

  getParamByName('root').then((param) {
    if (param.paramName.isEmpty) {
      param.paramName = 'root';
      param.stringVal = '192.168.2.65:5093';
      createParam(param);
    }
  });

  runApp(const MyApp());
}

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      title: 'Shaylan E-Comers application',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Builder(
        builder: (context) => Scaffold(
            appBar: AppBar(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.title),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  dropdownColor: Colors.blueGrey,
                  style: const TextStyle(color: Colors.white),
                  underline: Container(height: 2, color: Colors.white24),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      changeLanguage(value.toLowerCase());
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            )),
            drawer: BuildDrawer(),
            body: const SingleChildScrollView(child: ControllerArea())),
      ),
    );
  }

  changeLanguage(String name) {
    setState(() {
      locale = Locale(name == 'tm' ? 'tr' : name);
    });
  }
}

class ControllerArea extends StatefulWidget {
  const ControllerArea({super.key});

  @override
  State<ControllerArea> createState() => _ControllerAreaState();
}

class _ControllerAreaState extends State<ControllerArea> {
  bool isButtonPressed = false;

  late bool servicePermission = false;
  late LocationPermission permission;
  var batterLevelInfo;
  User user = User.defaultUser();

  Future<Position> _getCorentisLocatoin() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    runGetUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(height: 2, color: Colors.black),
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
              AppLocalizations.of(context)!.tradingagent,
              selectionColor: Colors.black,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )
          ],
        ),
      ),
      Container(height: 2, color: Colors.black),
      const TradingAgentGrive(),
      Container(height: 2, color: Colors.black),
      const MerchandaiserGrivew(),
      Container(height: 2, color: Colors.black),
      const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '0.0.4',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      )
    ]);
  }

  Widget _getChargeTime(AndroidBatteryInfo data) {
    if (data.chargingStatus == ChargingStatus.Charging) {
      return data.chargeTimeRemaining == -1
          ? const Text("Calculating charge time remaining")
          : Text(
              "Charge time remaining: ${(data.chargeTimeRemaining! / 1000 / 60).truncate()} minutes");
    }
    return const Text("Error");
  }

  Future logout() async {
    await removeUsers();
  }

  void runGetUser() async {
    user = await getUser();
    setState(() {});
  }
}
