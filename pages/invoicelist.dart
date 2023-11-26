import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testflutterapp/models/invoice.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/pages/payment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/connstring.dart';
import 'package:flutter/foundation.dart';

SharedPreferences? prefs;
String uid = '';

void invoiceList() {
  runApp(const SearchInvoice());
}

fetchUid() async {
  uid = (await getUser()).empId.toString();
  return uid;
}

Future<List<Invoice>> fetchInvoice() async {
  await fetchUid();

  final response = await http.get(Uri.http(await getIpAddressRoot(),
      '/api/Invoice/getinvoicebyowner', {'code': uid}));

  return compute(parseProps, response.body);
}

List<Invoice> parseProps(String responseBody) {
  var jsonData = json.decode(responseBody);
  final props = jsonData;

  return props.map<Invoice>((propJson) => Invoice.fromJson(propJson)).toList();
}

class SearchInvoice extends StatelessWidget {
  const SearchInvoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filterVal = '';
  List<Invoice> invoiceList = [];

  _HomePageState();

  @override
  initState() {
    filterVal = '';
    super.initState();
  }

  // This function is called whenever the text field changes

  void _runFilter(String enteredKeyword) {
    setState(() {
      filterVal = enteredKeyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.searchInvoic),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder<List<Invoice>>(
                    future: fetchInvoice(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ListTile> titleList = <ListTile>[];
                        invoiceList = snapshot.data!.toList();
                        for (var element in invoiceList.where((element) =>
                            element.CardName.toLowerCase()
                                .contains(filterVal))) {
                          titleList.add(ListTile(
                              title: Text(
                                  "Doc number: ${element.DocNum}; Customer:  ${element.CardName};"),
                              subtitle: Text(
                                  "Payment sum:  ${element.DocTotal} TMT;"),
                              onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentOption(
                                          invoice: element,
                                        ),
                                      ),
                                    )
                                  },
                              leading: const Icon(Icons.navigate_next),
                              trailing: Text("${element.DocDate} ")));
                        }
                        return ListView(
                          children: titleList,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {},
            label: Text(AppLocalizations.of(context)!.addPayment),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          ),
        ));
  }
}
/**/