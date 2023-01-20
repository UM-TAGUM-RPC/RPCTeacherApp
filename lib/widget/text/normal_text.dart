import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/constant.dart';

class GeneralSans extends StatelessWidget {
  final String? label;
  final TextAlign? align;
  final TextOverflow? overflow;
  final bool? medium, semiBold, bold;
  final double? fontSize;
  final Color? fontColor;

  const GeneralSans(
      {super.key,
      this.label,
      this.align,
      this.overflow,
      this.medium,
      this.semiBold,
      this.bold,
      this.fontSize,
      this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      label ?? "",
      maxLines: 100,
      textAlign: align ?? TextAlign.center,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        color: fontColor ?? CustomColor.darkColor,
        fontFamily: bold == true
            ? CustomFont.bold
            : medium == true
                ? CustomFont.medium
                : semiBold == true
                    ? CustomFont.semiBold
                    : CustomFont.regular,
        fontWeight: bold == true
            ? FontWeight.w700
            : medium == true
                ? FontWeight.w500
                : semiBold == true
                    ? FontWeight.w600
                    : FontWeight.w400,
        fontSize: fontSize ?? 15.sp,
      ),
    );
  }
}
