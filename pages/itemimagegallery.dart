import 'package:flutter/material.dart';
import 'package:testflutterapp/partial/drawer.dart';

class ItemImegeGallery extends StatefulWidget {
  const ItemImegeGallery({super.key});

  @override
  State<ItemImegeGallery> createState() => _ItemImegeGalleryState();
}

class _ItemImegeGalleryState extends State<ItemImegeGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: BuildDrawer(),
        appBar: AppBar(title: const Text("ImageGallery")));
  }
}
