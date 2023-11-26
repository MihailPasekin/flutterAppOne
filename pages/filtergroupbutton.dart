import 'package:flutter/material.dart';
import 'package:testflutterapp/models/itemgroup.dart';

// ignore: must_be_immutable
class FilterGroupButton extends StatefulWidget {
  ItemGroup itemGroup;
  Color btnColor = Colors.blue;
  Function runFilter;
  int groupFilter;

  FilterGroupButton(this.itemGroup, this.runFilter, this.groupFilter,
      {super.key}) {
    if (groupFilter == itemGroup.ItmsGrpCod) {
      btnColor = Colors.black;
    }
  }

  @override
  State<FilterGroupButton> createState() => _FilterGroupButtonState();
}

class _FilterGroupButtonState extends State<FilterGroupButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          widget.runFilter(widget.itemGroup);

          widget.btnColor = Colors.white;
        });
      },
      style: ElevatedButton.styleFrom(backgroundColor: widget.btnColor),
      child: Text(widget.itemGroup.ItmsGrpNam),
    );
  }
}
