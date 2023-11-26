import 'package:flutter/material.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/PlanMerch.dart';
import 'package:testflutterapp/pages/planmerchdetailpage.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlanPageMerch extends StatelessWidget {
  const PlanPageMerch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: BuildDrawer(),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.merchplan),
        ),
        body: FutureBuilder<List<PlanMerch>>(
          future:
              getUser().then((value) => getPlanMerch(value.empId.toString())),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.anErrorHasOccurred}${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return PlanMerchList(
                planMerchList: snapshot.data!,
              );
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
  const PlanMerchList({
    super.key,
    required this.planMerchList,
  });
  final List<PlanMerch> planMerchList;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: planMerchList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(planMerchList[index].PlanDate.toString()),
            subtitle: Text('${planMerchList[index].Coment.toString()};'),
            trailing: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 60,
                  minHeight: 60,
                  maxWidth: 80,
                  maxHeight: 80,
                ),
                child: const Text('')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlanDetailPage(
                    planMerch: planMerchList[index],
                  ),
                ),
              );
            },
          );
        },
      )),
      ElevatedButton.icon(
        icon: const Icon(Icons.west),
        label: Text(AppLocalizations.of(context)!.back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ]);
  }
}
