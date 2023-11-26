import 'package:camera/camera.dart';
import 'package:testflutterapp/models/custommerch.dart';
import 'package:testflutterapp/models/listtiletrailingwidget.dart';
import 'package:testflutterapp/models/merchgroup.dart';
import 'package:testflutterapp/models/tamerchvisit.dart';

String pathForPhoto = '';
List<CameraDescription> cameraDescriptionList = List.empty(growable: true);
List<MerchGroup> merchGroupList = List.empty(growable: true);
CustomMerch customMerch = CustomMerch.defaultCustomerMerch();
TAMerchVisit merchVisitGlobal = TAMerchVisit.defaultTAMerchVisit();

List<ListTileTrailngWidget> dictionaryOrderWidget = List.empty(growable: true);
