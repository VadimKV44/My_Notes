import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsIconButtonWidget extends StatelessWidget {
  const SettingsIconButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      width: 35.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onTap,
          child: SvgPicture.asset(
            'assets/icons/settings.svg',
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
