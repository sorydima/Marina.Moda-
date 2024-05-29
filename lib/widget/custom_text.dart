import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  final String title;
  final double size;
  FontWeight? fontWeight;
  Color? colors;
  TextAlign? textAlign;

  CustomText(
      {Key? key,
      required this.title,
      required this.size,
      this.fontWeight,
      this.colors,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          color: colors,
          fontSize: size,
          fontWeight: fontWeight ?? FontWeight.w600),
      textAlign: textAlign,
    );
  }
}
