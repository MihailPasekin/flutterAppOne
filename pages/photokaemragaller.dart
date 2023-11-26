import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:http/http.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/PlanMerch.dart';
import 'package:testflutterapp/models/connstring.dart';
import 'package:testflutterapp/models/photo.dart';
import 'package:testflutterapp/models/planedetailmerch.dart';
import 'package:testflutterapp/models/planreport.dart';
import 'package:testflutterapp/models/requestqueue.dart';
import 'package:testflutterapp/pages/camerbefore.dart';
import 'package:testflutterapp/pages/send/sendqueuewidgets/planmerchqueue.dart';
import 'package:testflutterapp/partial/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhotoGalleryBefore extends StatelessWidget {
  final PlanMerch planMerch;
  final PlanDetail planDetail;
  final String prevRoute;
  const PhotoGalleryBefore({
    super.key,
    required this.planMerch,
    required this.planDetail,
    String? route,
  }) : prevRoute = route ?? "";

  factory PhotoGalleryBefore.photoGaleriRoutAfter(String fromRoute,
      {required PlanMerch planMerch, required PlanDetail planDetail}) {
    return PhotoGalleryBefore(
      route: fromRoute,
      planMerch: planMerch,
      planDetail: planDetail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhotoGalleryWidget(
      planMerch: planMerch,
      planDetail: planDetail,
      prevRoute: prevRoute,
    );
  }
}

class PhotoGalleryWidget extends StatefulWidget {
  final PlanMerch planMerch;
  final PlanDetail planDetail;
  final String prevRoute;
  const PhotoGalleryWidget(
      {super.key,
      required this.planMerch,
      required this.planDetail,
      required this.prevRoute});

  @override
  State<PhotoGalleryWidget> createState() {
    return _PhotoGalleryWidgetState();
  }
}

class _PhotoGalleryWidgetState extends State<PhotoGalleryWidget> {
  List<PhotoWidget> listPhoto = List.empty(growable: true);
  _PhotoGalleryWidgetState();

  void deletphoto(int planDetailId, int planMerchId, String path) async {
    if (widget.prevRoute == 'before') {
      await removePhotoBeforeId(planMerchId, planDetailId, path);
    } else {
      await removePhotoAfterId(planMerchId, planDetailId, path);
    }
    setState(() {
      listPhoto.removeWhere((photoWidget) => photoWidget.path == path);
    });

    var file = File(path);
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: BuildDrawer(),
            appBar: AppBar(
                title: widget.prevRoute == "after"
                    ? Text(AppLocalizations.of(context)!.after)
                    : Text(AppLocalizations.of(context)!.before)),
            body: Column(children: [
              Expanded(
                  child: FutureBuilder<List<Photo>>(
                future: widget.prevRoute == 'before'
                    ? getPhotoBefore(
                        widget.planDetail.PlanDetailId, widget.planMerch.PlanId)
                    : getPhotoAfter(widget.planDetail.PlanDetailId,
                        widget.planMerch.PlanId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            '${AppLocalizations.of(context)!.anErrorHasOccurred}${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    listPhoto.clear();
                    for (var item in snapshot.data!.toList()) {
                      listPhoto.add(PhotoWidget(
                          planDetailId: widget.planDetail.PlanDetailId,
                          planMerchId: widget.planMerch.PlanId,
                          path: item.FullFileName,
                          removeWidget: deletphoto));
                    }
                    return SingleChildScrollView(
                      child: Column(children: listPhoto),
                    )

                        /*ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(15.0),
                        children: listPhoto)*/
                        ;
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
                  ElevatedButton(
                      onPressed: () {
                        if (widget.prevRoute == 'before') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraAwesomeApp.cameraAfter(
                                'before',
                                planMerch: widget.planMerch,
                                planDetail: widget.planDetail,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraAwesomeApp.cameraAfter(
                                'after',
                                planMerch: widget.planMerch,
                                planDetail: widget.planDetail,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.back)),
                  ElevatedButton(
                      onPressed: () async {
                        if (widget.prevRoute == 'before') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraAwesomeApp.cameraAfter(
                                'after',
                                planMerch: widget.planMerch,
                                planDetail: widget.planDetail,
                              ),
                            ),
                          );
                        } else {
                          PlanReport planReport =
                              PlanReport.defaultPlanReport();
                          planReport.EmpId = (await getUser()).empId;
                          planReport.PlanId = widget.planMerch.PlanId;
                          planReport.PlanDetailId =
                              widget.planDetail.PlanDetailId;
                          var photosBefore = await getPhotoBefore(
                              widget.planDetail.PlanDetailId,
                              widget.planMerch.PlanId);
                          for (var photo in photosBefore) {
                            planReport.Photos.add(photo);
                          }
                          var photoAfter = await getPhotoAfter(
                              widget.planDetail.PlanDetailId,
                              widget.planMerch.PlanId);
                          for (var photo in photoAfter) {
                            planReport.Photos.add(photo);
                          }
                          widget.planDetail.PlanDeteilStatus = 'COMPLIT';

                          updatePlanDetail(widget.planDetail);
                          String orderforserverJson = jsonEncode(planReport);
                          var orderQueue = OrderQueue(
                              api: '/api/MerchPlan/postcreateplanreport',
                              body: orderforserverJson,
                              createdDateTime: DateTime.now(),
                              sent: false,
                              sentDateTime: DateTime.now());
                          await createOrderQueue(orderQueue);
                          if (!context.mounted) return;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PlanMerchQueue()));
                        }
                      },
                      child: widget.prevRoute == 'before'
                          ? Text(AppLocalizations.of(context)!.next)
                          : Text(AppLocalizations.of(context)!.sendReport))
                ],
              ),
            ])));
  }
}

Future<Response> uploadImageHTTP(File file) async {
  Dio dio = Dio();
  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(file.path, filename: fileName),
  });
  var response = await dio.post(
      'http://${await getIpAddressRoot()}/api/MerchPlan/postmerchplanphoto',
      data: formData);
  return response;
}

class PhotoWidget extends StatelessWidget {
  final String path;
  final int planMerchId;
  final int planDetailId;
  final Function(int, int, String) removeWidget;
  const PhotoWidget(
      {super.key,
      required this.path,
      required this.removeWidget,
      required this.planMerchId,
      required this.planDetailId});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
          elevation: 8.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Image.file(File(path)),
          )),
      ElevatedButton(
          onPressed: () {
            removeWidget(planDetailId, planMerchId, path);
          },
          child: Text(AppLocalizations.of(context)!.delete))
    ]);
  }
}
/**/