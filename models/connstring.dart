import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/param.dart';

//String root = '192.168.0.70:5093';

Future<String> getIpAddressRoot()async{
  Param param = await getParamByName("root");
  return param.stringVal;
}
