import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testflutterapp/models/item.dart';

// ignore: must_be_immutable
class AddCountButtons extends StatefulWidget {
  Item initCount;

  AddCountButtons({super.key, required this.initCount});

  @override
  State<AddCountButtons> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddCountButtons> {
  void addValue() {
    setState(() {
      widget.initCount.ItemCountForOrder++;
    });
  }

  void minusValue() {
    setState(() {
      widget.initCount.ItemCountForOrder--;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: 170,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                addValue();
              },
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child:
                        Text(widget.initCount.ItemCountForOrder.toString()))),
            IconButton(
              onPressed: () {
                minusValue();
              },
              icon: const Icon(Icons.remove),
            ),
          ],
        ));
  }
}

class AddCountButtonsStLess extends StatefulWidget {
  final Function addValue;
  final Function minusValue;
  final Function setValue;
  final Item item;

  const AddCountButtonsStLess(
      {super.key,
      required this.addValue,
      required this.minusValue,
      required this.setValue,
      required this.item});

  @override
  State<AddCountButtonsStLess> createState() => _AddCountButtonsStLessState();
}

class _AddCountButtonsStLessState extends State<AddCountButtonsStLess> {
  final TextEditingController controllerText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var numberInputFormatters = [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    ];

    controllerText.text = widget.item.ItemCountForOrder.toString();
    return SizedBox(
        height: 50,
        width: 180,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: [
              Container(
                height: 30,
                width: 55,
                child: ElevatedButton(
                  child: const Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    widget.addValue();
                  },
                ),
              ),
              Container(
                height: 12,
                width: 12,
              )
            ]),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: numberInputFormatters,
                    maxLength: 4,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (val) {
                      if (val == "") {
                        widget.setValue(0);
                      } else {
                        widget.setValue(int.parse(val));
                      }
                    },
                    controller: controllerText,
                  )),
            ),
            Column(children: [
              Container(
                height: 30,
                width: 55,
                child: ElevatedButton(
                  child: const Icon(
                    Icons.remove,
                  ),
                  onPressed: () {
                    widget.minusValue();
                  },
                ),
              ),
              Container(
                height: 12,
                width: 12,
              )
            ]),
          ],
        ));
  }
}
