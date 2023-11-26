import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/PlanMerch.dart';
import 'package:testflutterapp/models/photo.dart';
import 'package:testflutterapp/models/planedetailmerch.dart';
import 'package:testflutterapp/models/planreport.dart';
import 'package:testflutterapp/pages/photokaemragaller.dart';
import 'package:testflutterapp/pages/planmerchdetailpage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraAwesomeApp extends StatelessWidget {
  final PlanMerch planMerch;
  final String prevRoute;
  final PlanDetail planDetail;

  const CameraAwesomeApp({
    super.key,
    required this.planMerch,
    required this.planDetail,
    String? route,
  }) : prevRoute = route ?? "";

  factory CameraAwesomeApp.cameraAfter(String fromRoute,
      {required PlanMerch planMerch, required PlanDetail planDetail}) {
    return CameraAwesomeApp(
      route: fromRoute,
      planMerch: planMerch,
      planDetail: planDetail,
    );
  }
  @override
  Widget build(BuildContext context) {
    return CameraPage(
      inplanMerch: planMerch,
      route: prevRoute,
      planDetail: planDetail,
    );
  }
}

// ignore: must_be_immutable
class CameraPage extends StatelessWidget {
  final PlanMerch inplanMerch;
  final String prevRoute;
  final PlanDetail planDetail;
  List<String> pathList = List.empty(growable: true);
  PlanReport reportPlan = PlanReport.defaultPlanReport();
  CameraPage({
    super.key,
    required this.inplanMerch,
    String? route,
    required this.planDetail,
  }) : prevRoute = route ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MaterialApp(
            title: 'camerAwesome',
            home: Container(
                color: Colors.white,
                child: CameraAwesomeBuilder.awesome(
                  aspectRatio: CameraAspectRatios.ratio_1_1,
                  enablePhysicalButton: true,
                  filter: AwesomeFilter.None,
                  middleContentBuilder: (state) {
                    return const Column(
                      children: [],
                    );
                  },
/*
            onMediaTap: (mediaCapture) {
              // Hande tap on the preview of the last media captured
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              );
              print('Tap on ${mediaCapture.filePath}');
            },*/
                  onPreviewTapBuilder: (state) => OnPreviewTap(
                    onTap: (position, flutterPreviewSize, pixelPreviewSize) {},
                    onTapPainter: (position) {
                      return Positioned(
                        left: position.dx - 25,
                        top: position.dy - 25,
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                      );
                    },
                    tapPainterDuration: const Duration(seconds: 2),
                  ),
                  onPreviewScaleBuilder: (state) => OnPreviewScale(
                    onScale: (scale) {
                      state.sensorConfig.setZoom(scale);
                    },
                  ),
                  previewAlignment: Alignment.center,
                  previewFit: CameraPreviewFit.fitWidth,
                  previewPadding: const EdgeInsets.all(20),
                  progressIndicator: const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  saveConfig: SaveConfig.photo(
                    pathBuilder: () => path(prevRoute, inplanMerch.PlanId),
                  ),
                  theme: AwesomeTheme(
                    buttonTheme: AwesomeButtonTheme(
                      iconSize: 28,
                      padding: const EdgeInsets.all(18),
                      foregroundColor: Colors.lightBlue,
                      buttonBuilder: (child, onTap) {
                        return ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: onTap,
                              child: child,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topActionsBuilder: (state) {
                    return AwesomeTopActions(
                      state: state,
                      children: [
                        AwesomeFlashButton(state: state),
                        Text(
                          prevRoute == "before"
                              ? AppLocalizations.of(context)!.before
                              : AppLocalizations.of(context)!.after,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            decorationColor: Colors.black,
                          ),
                        )
                      ],
                    );
                  },
                  bottomActionsBuilder: (state) {
                    return AwesomeBottomActions(
                      state: state,
                      left: TextButton(
                          onPressed: () {
                            if (prevRoute == "before") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlanDetailPage(
                                          planMerch: inplanMerch,
                                        )),
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoGalleryBefore(
                                            planMerch: inplanMerch,
                                            planDetail: planDetail,
                                            route: 'before',
                                          )));
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.back)),
                      right: TextButton(
                          onPressed: () {
                            if (prevRoute == "before") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoGalleryBefore(
                                            planMerch: inplanMerch,
                                            planDetail: planDetail,
                                            route: 'before',
                                          )));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoGalleryBefore(
                                            planMerch: inplanMerch,
                                            planDetail: planDetail,
                                            route: 'after',
                                          )));
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.next)),
                    );
                  },
                ))));
  }

  Future<String> path(String str, int planId) async {
    String datatime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String name = '${datatime}_${(await getUser()).empId.toString()}_$planId';
    String path =
        '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}${str}_${datatime}_${(await getUser()).empId.toString()}_$planId.jpg';
    Photo photobefore = Photo(
        PlanId: planId,
        PlanDetailId: planDetail.PlanDetailId,
        CreatedAt: inplanMerch.CreatedAt,
        PhotoName: name,
        FullFileName: path,
        Period: prevRoute);
    if (prevRoute == "before") {
      createBeforePhoto(photobefore);
    } else {
      createAfterPhoto(photobefore);
    }
    return path;
  }
}
/**/