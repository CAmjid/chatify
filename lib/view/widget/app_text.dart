import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String name;
  final double? fontsize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? align;

  const AppText({
    super.key,
    required this.name,
    this.fontsize,
    this.color,
    this.fontWeight,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: align ?? TextAlign.start,
      style: GoogleFonts.montserrat(
        color: color,
        fontSize: fontsize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
    );
  }
}
