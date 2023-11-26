import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
String uid='';

fetchUid() async {
  await SharedPreferences.getInstance().then((prefs) =>
  uid = prefs.getString('uid')!);
  return uid;
}

Widget makeRoute(
    {required BuildContext context,
      required String routeName,
      //required Object arguments
      }) {
  final Widget child =
  _buildRoute(context: context, routeName: routeName);//, arguments: arguments);
  return child;
}

Widget _buildRoute({
  required BuildContext context,
  required String routeName,
 // required Object arguments,
}) {
  switch (routeName) {
    case '/':
      return const MyApp();
    case '/profile':
      return ProfilePage();
    default:
      throw 'Route $routeName is not defined';
  }
}