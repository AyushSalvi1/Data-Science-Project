// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextFieldLabelWidget extends StatelessWidget {
  const TextFieldLabelWidget({
    super.key,
    required this.label,
    required this.child,
  });

  final String? label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        label != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Gap(4),
                ],
              )
            : SizedBox.shrink(),
        child
      ],
    );
  }
}
