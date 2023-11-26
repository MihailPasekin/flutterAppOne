import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/models/merchproductgroup.dart';
import 'package:testflutterapp/pages/merchproductpage.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MerchProductGroupPage extends StatelessWidget {
  final Customer customer;

  const MerchProductGroupPage({Key? key, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MerchProductGroupPageList(
      customer: customer,
    );
  }
}

class MerchProductGroupPageList extends StatefulWidget {
  final Customer customer;

  const MerchProductGroupPageList({Key? key, required this.customer})
      : super(key: key);

  @override
  State<MerchProductGroupPageList> createState() =>
      _MerchProductGroupPageListState();
}

class _MerchProductGroupPageListState extends State<MerchProductGroupPageList> {
  String filterVal = '';
  List<MerchProductGroup> itemList = List.empty(growable: true);
  List<MerchProductGroup> checkedProductGroupList = List.empty(growable: true);
  @override
  initState() {
    filterVal = '';
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      filterVal = enteredKeyword;
    });
  }

  void addMerchItemGradeListOrder(MerchProductGroup productGroup) {
    if (checkedProductGroupList.contains(productGroup)) {
      checkedProductGroupList.remove(productGroup);
      checkedProductGroupList.add(productGroup);
    } else {
      checkedProductGroupList.add(productGroup);
    }
  }

  bool getInitialValue(MerchProductGroup merchProductGroup) {
    bool result = false;
    Iterable<MerchProductGroup> merchSkuScores = checkedProductGroupList.where(
        (element) => element.merchGroupId == merchProductGroup.merchGroupId);
    if (merchSkuScores.isNotEmpty) {
      if (merchSkuScores.length == 1) {
        result = merchSkuScores.single.checked;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: BuildDrawer(),
          appBar: AppBar(
            title: const Text("Merch Group"),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder<List<MerchProductGroup>>(
                    future: getMerchProduktGroup(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ListTile> titleList = <ListTile>[];
                        itemList = snapshot.data!.toList();
                        titleList.clear();
                        for (var element in itemList) {
                          titleList.add(ListTile(
                              title: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MerchProductPage(
                                            customer: widget.customer,
                                            merchProducktGroup: element,
                                          )));
                            },
                            child: Text(
                              "${element.merchGroupName} ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                              // trailing: SizedBox(
                              //     width: 65,
                              //     height: 60,
                              //     child: CheckboxListTile(
                              //       tristate: false,
                              //       tileColor: Colors.white24,
                              //       value: getInitialValue(element),
                              //       onChanged: (bool? value) {
                              //         setState(() {
                              //           element.checked = value ?? false;
                              //           addMerchItemGradeListOrder(element);
                              //         });
                              //       },
                              //     ))
                              ));
                        }
                        return ListView(
                          children: titleList,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
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
              ])),
        ));
  }
}
