import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 30,
        height: 30,
        child: SvgPicture.asset('assets/icons/google-icon.svg'));
  }
}
