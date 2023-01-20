import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/constant.dart';
import '../widget.dart';

class ButtonRounded extends StatelessWidget {
  final void Function()? onPressed;
  final String? label;
  final double? fontSize, round, width, heigth;
  final Color? fontColor, backColor;

  const ButtonRounded(
      {super.key,
      this.onPressed,
      this.label,
      this.fontSize,
      this.round,
      this.width,
      this.heigth,
      this.fontColor,
      this.backColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heigth ?? 55.h,
      width: width ?? 200.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: backColor ?? CustomColor.kindaRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(round ?? 0.0),
            )),
        child: Center(
          child: GeneralSans(
            label: label ?? "",
            fontColor: fontColor ?? CustomColor.white,
            fontSize: fontSize ?? 20.sp,
            bold: true,
          ),
        ),
      ),
    );
  }
}
