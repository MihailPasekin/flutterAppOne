import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/main.dart';
import 'package:testflutterapp/models/delivery.dart';
import 'package:testflutterapp/models/user.dart';
import 'package:testflutterapp/pages/deliveryitempage.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CastomerDelivery extends StatefulWidget {
  final User user;
  const CastomerDelivery({super.key, required this.user});
  @override
  State<CastomerDelivery> createState() => _CastomerDelivery();
}

class _CastomerDelivery extends State<CastomerDelivery> {
  String filterVal = '';
  _CastomerDelivery();

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
          appBar: AppBar(
            title: const Text('list'),
          ),
          drawer: BuildDrawer(),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.search,
                    suffixIcon: const Icon(Icons.search)),
              ),
              Expanded(
                  child: FutureBuilder<List<Delivery>>(
                future: getListDelivery(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.anErrorHasOccurred}${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return CastomerDeliveryList(
                        deliveryList: snapshot.data!
                            .toList()
                            .where((element) =>
                                element.cardName.contains(filterVal))
                            .toList());
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
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
                              builder: (context) => const MyApp()));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}

class CastomerDeliveryList extends StatefulWidget {
  final List<Delivery> deliveryList;
  const CastomerDeliveryList({super.key, required this.deliveryList});

  @override
  State<CastomerDeliveryList> createState() => _CastomerDeliveryListState();
}

class _CastomerDeliveryListState extends State<CastomerDeliveryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // padding: const EdgeInsets.all(8),
      itemCount: widget.deliveryList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            widget.deliveryList[index].cardName.toString(),
          ),
          subtitle: Column(children: [
            Padding(
                padding: const EdgeInsets.only(right: 54),
                child: Text(
                  'Töleg görnüşi: ${widget.deliveryList[index].payType.toString()}',
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
            Row(children: <Widget>[
              const Text(
                'Sum: ',
                style: TextStyle(fontSize: 25),
              ),
              Text(
                '${widget.deliveryList[index].docTotal.toString()} TMT',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ]),
          trailing: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 60,
                minHeight: 60,
                maxWidth: 80,
                maxHeight: 80,
              ),
              child: Text(widget.deliveryList[index].docDate)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliveryItemPage(
                  delivery: widget.deliveryList[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
