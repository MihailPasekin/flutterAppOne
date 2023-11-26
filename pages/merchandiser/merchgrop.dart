import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/globalvariables.dart';
import 'package:testflutterapp/models/merchgroupscore.dart';
import 'package:testflutterapp/pages/merchandiser/merchitemgrade.dart';
import 'package:testflutterapp/models/customer.dart';
import 'package:testflutterapp/models/merchgroup.dart';
import 'package:testflutterapp/pages/merchandiser/sendmerchreport.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MerchGrovControl extends StatefulWidget {
  final String cardName;
  final Customer customer;

  const MerchGrovControl(
      {super.key, required this.cardName, required this.customer});

  @override
  State<MerchGrovControl> createState() => _MerchGrovControlState();
}

class _MerchGrovControlState extends State<MerchGrovControl> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(),
            drawer: BuildDrawer(),
            body: Column(children: [
              Container(
                height: 6,
              ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    getUser().then((value) {
                      if (value.empId > 0) {
                        customMerch.EmpID = value.empId;
                        customMerch.Created = DateTime.now().toString();
                        customMerch.CardCode = widget.customer.CardCode;
                        customMerch.Comment = "Test";
                        for (var element in merchGroupList) {
                          if (element.checked == true) {
                            MerchGroupScore merchGroupScore = MerchGroupScore(
                                visitId: 0, groupId: element.GroupId);
                            customMerch.GroupScoreList.add(merchGroupScore);
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MerchItemGrade(
                              cardName: widget.cardName,
                              customer: widget.customer,
                            ),
                          ),
                        );
                      }
                    });
                  },
                  child: const Text(
                    'GredeBydeSKU',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<MerchGroup>>(
                  future: MerchGroup.fetchMerchGroup(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('An error has occurred!${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      merchGroupList = snapshot.data!.toList();
                      return PropsList(widget.customer.CardCode);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ])));
  }
}

class PropsList extends StatefulWidget {
  final String cardCode;
  const PropsList(this.cardCode, {super.key});
  @override
  State<PropsList> createState() {
    return _PropsListWidgetState();
  }
}

class _PropsListWidgetState extends State<PropsList> {
  _PropsListWidgetState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: merchGroupList.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            tristate: false,
            tileColor: Colors.white,
            title: Text(merchGroupList[index].GroupName.toString()),
            value: merchGroupList[index].checked ?? false,
            onChanged: (bool? value) {
              setState(() {
                merchGroupList[index].checked = value;
              });
            },
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            width: 120,
            height: 2,
            color: Colors.blueGrey,
          );
        },
      )),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.west),
          label: Text(AppLocalizations.of(context)!.backToOrders),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.next),
            onPressed: () {
              getUser().then((value) {
                if (value.empId > 0) {
                  customMerch.EmpID = value.empId;
                  customMerch.Created = DateTime.now().toString();
                  customMerch.CardCode = widget.cardCode;
                  customMerch.Comment = "Test";
                  for (var element in merchGroupList) {
                    if (element.checked == true) {
                      MerchGroupScore merchGroupScore =
                          MerchGroupScore(visitId: 0, groupId: element.GroupId);
                      customMerch.GroupScoreList.add(merchGroupScore);
                    }
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MechSendReport(customMerch: customMerch)));
                }
              });
            })
      ]),
    ]);
  }
}
