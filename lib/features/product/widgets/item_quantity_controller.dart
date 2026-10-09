import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ItemQuantityController extends StatefulWidget {
  const ItemQuantityController({
    super.key,
    this.initialQuantity = 1,
    this.label,
    required this.getQuantity,
    this.onIncrementQuantity,
    this.onDecrementQuantity,
  });
  final int initialQuantity;
  final String? label;
  final void Function(int quantity) getQuantity;
  final void Function()? onIncrementQuantity;
  final void Function()? onDecrementQuantity;

  @override
  State<ItemQuantityController> createState() => _ProductQuantityCounterState();
}

class _ProductQuantityCounterState extends State<ItemQuantityController> {
  late int counter;
  @override
  void initState() {
    counter = widget.initialQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextTheme.of(context).bodyLarge!.copyWith(),
      child: widget.label == null
          ? _buildQuantityCounter()
          : Center(
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label!,
                    style: TextTheme.of(context)
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Gap(12),
                  _buildQuantityCounter()
                ],
              ),
            ),
    );
  }

  Row _buildQuantityCounter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: counter == 1
                ? null
                : () {
                    setState(() {
                      if (counter > 1) {
                        counter--;
                        widget.onDecrementQuantity?.call();
                        widget.getQuantity(counter);
                      }
                    });
                  },
            icon: Icon(Icons.remove)),
        Text(counter.toString()),
        IconButton(
            onPressed: () {
              setState(() {
                counter++;
                widget.onIncrementQuantity?.call();
                widget.getQuantity(counter);
              });
            },
            icon: Icon(Icons.add)),
      ],
    );
  }
}
