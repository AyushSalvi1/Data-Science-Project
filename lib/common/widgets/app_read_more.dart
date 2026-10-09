import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class AppReadMore extends StatelessWidget {
  const AppReadMore(this.text, {super.key, this.trimLines = 4, this.style});
  final String text;
  final int trimLines;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimMode: TrimMode.Line,
      trimLines: trimLines,
      colorClickableText: Colors.pink,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      moreStyle: style,
    );
  }
}
