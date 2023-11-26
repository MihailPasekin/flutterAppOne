import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/pages/invoicelist.dart';
import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/models/order.dart';
import 'package:testflutterapp/models/user.dart';
import 'package:testflutterapp/pages/orderlist.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:testflutterapp/pages/searchbp.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final Customer customer = Customer.defaultCustomer();
  final Item itemDef = Item.defaultItem();
  final List<Customer> customerList = List.empty(growable: true);
  final List<Item> itemList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.profile),
            ),
            drawer: BuildDrawer(),
            body: FutureBuilder<User>(
                future: getUser(), // fetchProps(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('An error has occurred!${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return SafeArea(
                        child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ('${snapshot.data?.firstName} '),
                                style: const TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.blueGrey,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          (snapshot.data?.lastName ?? ""),
                          style: const TextStyle(
                              fontSize: 22.0,
                              color: Colors.blueGrey,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          (snapshot.data?.mobile ?? ""),
                          style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black45,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            elevation: 2.0,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 30),
                                child: Text(
                                  AppLocalizations.of(context)!.achievements,
                                  style: const TextStyle(
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w300),
                                ))),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!.salesAgent,
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black45,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.orders,
                                        style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      FutureBuilder<String>(
                                          future: Order.getOrderCount(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              );
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          })
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        "TMT",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      FutureBuilder<String>(
                                          future: Order.getOrdersSumm(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              );
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyListingPage(
                                            uid: snapshot.data!.empId
                                                .toString())));
                              },
                              child: Text(
                                AppLocalizations.of(context)!.myOrders,
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchBP(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.addOrder,
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchInvoice(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.invoiceList,
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        const Expanded(flex: 20, child: Text(" ")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.west),
                              label: Text(AppLocalizations.of(context)!.back),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyApp(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Expanded(
                            child: Container(
                          height: 10,
                        ))
                      ],
                    ));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })));
  }
}
