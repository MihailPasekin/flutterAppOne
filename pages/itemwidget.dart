import 'package:flutter/material.dart';
import 'package:testflutterapp/itempichename.dart';

import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/pages/addcountbuttons.dart';
import 'package:testflutterapp/pages/itemgalery.dart';

// ignore: must_be_immutable
class ItemWidget extends StatefulWidget {
  Item item;
  Function addItemToOrderListItems;
  ItemWidget(this.item, this.addItemToOrderListItems, {super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 165,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0xFFEFF2F4)),
          top: BorderSide(color: Color(0xFFEFF2F4)),
          right: BorderSide(color: Color(0xFFEFF2F4)),
          bottom: BorderSide(width: 1, color: Color(0xFFEFF2F4)),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 110,
            top: 58,
            child: SizedBox(
              width: 250,
              child: Text(
                widget.item.ItemName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Positioned(
            left: 98,
            top: 15,
            child: SizedBox(
                width: 320,
                child: Stack(children: [
                  Positioned(
                    child: Container(
                      width: 100,
                      child: Text(
                        "Quantity: ${widget.item.ItemCount}",
                        style: const TextStyle(
                          color: Color(0xFF1C1C1C),
                          fontSize: 17,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 110,
                    child: Container(
                      width: 180,
                      child: Text(
                        "Cod ${widget.item.ItemCode}",
                        style: const TextStyle(
                          color: Color(0xFF1C1C1C),
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ])),
          ),
          Positioned(
            left: 4,
            top: 4,
            child: SizedBox(
              width: 92,
              height: 112,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 92,
                      height: 112,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(width: 1, color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 3,
                    top: 3,
                    child: Container(
                      width: 86,
                      height: 106,
                      padding: const EdgeInsets.only(),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60.76,
                            height: 116.76,
                            child: ItemPictureName(
                              hei: 50,
                              wid: 40,
                              getimageFile: getimageFile,
                              item: widget.item,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 295,
            top: 135,
            child: Text(
              'TMT ${widget.item.Price}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF1C1C1C),
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 122,
            child: SizedBox(
              child: Stack(
                children: [
                  AddCountButtonsStLess(
                      addValue: () {
                        setState(() {
                          widget.item.ItemCountForOrder++;
                          if (widget.item.ItemCountForOrder >= 0) {
                            widget.addItemToOrderListItems(widget.item);
                            if (widget.item.ItemCountForOrder > 0) {
                              widget.item.ItemForOrder = true;
                            } else {
                              widget.item.ItemForOrder = true;
                            }
                          }
                        });
                      },
                      minusValue: () {
                        setState(() {
                          widget.item.ItemCountForOrder--;
                          if (widget.item.ItemCountForOrder >= 0) {
                            widget.addItemToOrderListItems(widget.item);
                            if (widget.item.ItemCountForOrder > 0) {
                              widget.item.ItemForOrder = true;
                            } else {
                              widget.item.ItemForOrder = true;
                            }
                          }
                        });
                      },
                      setValue: (int val) {
                        setState(() {
                          widget.item.ItemCountForOrder = val;
                          if (widget.item.ItemCountForOrder >= 0) {
                            widget.addItemToOrderListItems(widget.item);
                            if (widget.item.ItemCountForOrder > 0) {
                              widget.item.ItemForOrder = true;
                            } else {
                              widget.item.ItemForOrder = true;
                            }
                          }
                        });
                      },
                      item: widget.item)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
