import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/PlanMerch.dart';
import 'package:testflutterapp/models/planedetailmerch.dart';
import 'package:testflutterapp/pages/camerbefore.dart';
import 'package:testflutterapp/pages/planmerch.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlanDetailPage extends StatelessWidget {
  final PlanMerch planMerch;

  const PlanDetailPage({
    super.key,
    required this.planMerch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: BuildDrawer(),
        appBar: AppBar(
          title: const Text(""),
        ),
        body: FutureBuilder<List<PlanDetail>>(
          future: getPlanMerchDetail(planMerch.PlanId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.anErrorHasOccurred}${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              planMerch.PlanDetails = snapshot.data!.toList();
              return PlanMerchList(planMerchList: planMerch);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class PlanMerchList extends StatelessWidget {
  const PlanMerchList({super.key, required this.planMerchList});

  final PlanMerch planMerchList;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: planMerchList.PlanDetails!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title:
                  Text(planMerchList.PlanDetails![index].CardName.toString()),
              trailing: planMerchList.PlanDetails![index].PlanDeteilStatus
                          .toString() ==
                      'ACTIVE'
                  ? Text(
                      AppLocalizations.of(context)!.active.toString(),
                      style: const TextStyle(color: Colors.red),
                    )
                  : Text(AppLocalizations.of(context)!.closed,
                      style: const TextStyle(color: Colors.green)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraAwesomeApp.cameraAfter(
                      'before',
                      planMerch: planMerchList,
                      planDetail: planMerchList.PlanDetails![index],
                    ),
                  ),
                );
              },
            );
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlanPageMerch()));
            },
          ),
        ],
      )
    ]);
  }
}
