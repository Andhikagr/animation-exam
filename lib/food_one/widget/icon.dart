import 'package:flutter/material.dart';

class ChooseIcons extends StatelessWidget {
  final Icon icons;
  final VoidCallback? onTap;
  final Color colorIcon;

  const ChooseIcons({
    super.key,
    required this.icons,
    this.onTap,
    required this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onTap, icon: icons, color: colorIcon);
  }
}
