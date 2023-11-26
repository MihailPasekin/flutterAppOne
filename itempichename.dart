import 'package:flutter/material.dart';
import 'package:testflutterapp/models/item.dart';

// ignore: must_be_immutable
class ItemPictureName extends StatelessWidget {
  var getimageFile;
  double wid;
  double hei;
  ItemPictureName(
      {super.key,
      required this.hei,
      required this.wid,
      required this.getimageFile,
      required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: 2,
        child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox.fromSize(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Material(
                    color: const Color.fromARGB(24, 247, 245, 245),
                    child: InkWell(
                      splashColor: const Color.fromARGB(24, 247, 245, 245),
                      onTap: () {
                        (item.LocalPictureName ?? "").isNotEmpty
                            ? showDialog(
                                context: context,
                                builder: (context) => Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                              color: Colors.white,
                                              child: Column(children: [
                                                SizedBox(
                                                    width: 700,
                                                    height: 700,
                                                    child: InteractiveViewer(
                                                      panEnabled: false,
                                                      minScale: 0.3,
                                                      maxScale: 4,
                                                      child: Image.file(
                                                        getimageFile(item
                                                            .LocalPictureName!),
                                                      ),
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    child: Text(item.ItemName)),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Ok"))
                                              ]))),
                                    ))
                            : const Icon(Icons.account_circle);
                      },
                      child: Transform.scale(
                          scale: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              (item.LocalPictureName ?? "").isNotEmpty
                                  ? Image.file(
                                      getimageFile(item.LocalPictureName!),
                                      width: wid,
                                      height: hei,
                                    )
                                  : const Icon(Icons.account_circle),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            )));
  }
}
