import 'package:flutter/material.dart';

class TextOrder extends StatelessWidget {
  final String textItem;
  final Color colorItem;
  final double sizeText;
  final bool isBold;
  final bool isCenter;

  const TextOrder({
    super.key,
    required this.textItem,
    required this.colorItem,
    required this.sizeText,
    this.isBold = false,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: isCenter ? TextAlign.center : TextAlign.justify,
      textItem,
      style: TextStyle(
        color: colorItem,
        fontSize: sizeText,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
