import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/models/custommerch.dart';
import 'package:testflutterapp/pages/customermanagerinformation.dart';
import 'package:testflutterapp/pages/historytrading.dart';
import 'package:testflutterapp/pages/merchandiser/merchgrop.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/pages/searchitem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchBP extends StatelessWidget {
  final String prevRoute;

  const SearchBP({super.key, String? route}) : prevRoute = route ?? "";

  factory SearchBP.serchbpMerch(String fromRoute) {
    return SearchBP(route: fromRoute);
  }

  factory SearchBP.sechbpreportTrading(String fromRoute) {
    return SearchBP(route: fromRoute);
  }
  factory SearchBP.sechbpHistoryTrading(String fromRoute) {
    return SearchBP(route: fromRoute);
  }
  @override
  Widget build(BuildContext context) {
    return HomePage(route: prevRoute);
  }
}

class HomePage extends StatefulWidget {
  final String prevRoute;
  const HomePage({super.key, String? route}) : prevRoute = route ?? "";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filterVal = '';
  Customer customer = Customer.defaultCustomer();
  _HomePageState();
  @override
  initState() {
    //filterVal = '';

    super.initState();
  }

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
            title: Text(AppLocalizations.of(context)!.searchCustomer),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      suffixIcon: const Icon(Icons.search)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder<List<Customer>>(
                    future: getListCustomers(filterVal),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ListTile> titleList = <ListTile>[];
                        for (var element in snapshot.data!) {
                          titleList.add(ListTile(
                              title: Text(
                                  "${element.CardCode};  ${element.CardName};"),
                              onTap: () => {
                                    if (widget.prevRoute == "merch")
                                      {
                                        customMerch =
                                            CustomMerch.defaultCustomerMerch(),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MerchGrovControl(
                                                        cardName:
                                                            element.CardName,
                                                        customer: element)))
                                      }
                                    else if (widget.prevRoute == "History")
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HistoryTrading(
                                                      cardCode:
                                                          element.CardCode,
                                                    )))
                                      }
                                    else if (widget.prevRoute ==
                                        "ReportTrading")
                                      {
                                        getUser().then((value) {
                                          if (value.empId > 0) {
                                            merchVisitGlobal.visitDateTime =
                                                DateTime.now()
                                                    .toIso8601String();
                                            merchVisitGlobal.cardCode =
                                                element.CardCode;
                                            merchVisitGlobal.empId =
                                                value.empId;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerManagerInformation(
                                                            customer:
                                                                element)));
                                          }
                                        })
                                      }
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SearchItem(
                                                cardName: element.CardName,
                                                customer: element),
                                          ),
                                        )
                                      }
                                  },
                              leading: const Icon(Icons.navigate_next)));
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.west),
                      label: Text(AppLocalizations.of(context)!.back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
