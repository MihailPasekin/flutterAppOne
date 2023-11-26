import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/models/merchproduct.dart';
import 'package:testflutterapp/models/merchproductgroup.dart';
import 'package:testflutterapp/pages/merccheked.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MerchProductPage extends StatelessWidget {
  final Customer customer;
  final MerchProductGroup merchProducktGroup;

  const MerchProductPage(
      {Key? key, required this.customer, required this.merchProducktGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage(
      customer: customer,
      merchProducktGroup: merchProducktGroup,
    );
  }
}

class HomePage extends StatefulWidget {
  final Customer customer;
  final MerchProductGroup merchProducktGroup;
  const HomePage({
    Key? key,
    required this.customer,
    required this.merchProducktGroup,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filterVal = '';
  final formKey = GlobalKey<FormState>();

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

  void addMerchItemGradeListOrder(MerchProduct merchProduct) {
    if (merchVisitGlobal.itemList.contains(merchProduct)) {
      merchVisitGlobal.itemList.remove(merchProduct);
      merchVisitGlobal.itemList.add(merchProduct);
    } else {
      merchVisitGlobal.itemList.add(merchProduct);
    }
  }

  MerchProduct getInitialProductValue(MerchProduct merchProduct) {
    Iterable<MerchProduct> merchSkuScores = merchVisitGlobal.itemList.where(
        (element) => element.MerchProductId == merchProduct.MerchProductId);
    if (merchSkuScores.isNotEmpty) {
      if (merchSkuScores.length == 1) {
        merchProduct = merchSkuScores.single;
      }
    }

    return merchProduct;
  }

  List<Widget> getWidgetComment(MerchProduct product) {
    List<Widget> widgetList = List.empty(growable: true);
    if (product.checked) {
      widgetList.add(Text(
        "${product.MerchProductName}; ",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
    } else {
      widgetList.addAll([
        Text(
          "${product.MerchProductName}; ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
            keyboardType: TextInputType.text,
            maxLines: 2,
            initialValue: getInitialProductValue(product).MerchProductComment,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.comment,
                hintText: ''),
            onChanged: (val) {
              product.MerchProductComment = val;
              addMerchItemGradeListOrder(product);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            })
      ]);
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(
              title: const Text("Choose goods"),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Expanded(
                      child: FutureBuilder<List<MerchProduct>>(
                        future: getMerchProdukt(
                            widget.merchProducktGroup.merchGroupId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<ListTile> titleList = <ListTile>[];
                            for (var element in snapshot.data!.toList()) {
                              titleList.add(ListTile(
                                  title: Column(
                                    children: getWidgetComment(
                                        getInitialProductValue(element)),
                                  ),
                                  trailing: Checkbox(
                                    tristate: false,
                                    value:
                                        getInitialProductValue(element).checked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        element.checked = value ?? false;
                                        addMerchItemGradeListOrder(element);
                                      });
                                    },
                                  )));
                            }
                            return ListView(
                              shrinkWrap: true,
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
                        ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: Text(AppLocalizations.of(context)!.next),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MerchCheked()));
                              }
                            })
                      ],
                    ),
                  ])),
            )));
  }
}
