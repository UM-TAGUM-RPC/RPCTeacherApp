import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/constant.dart';

class TexFormFieldBar extends StatelessWidget {
  final double? width;
  final TextInputType? inputType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? hintText, svgIcon;
  final TextEditingController? controller;
  final bool? haveBorder, obsecureText, showPassIcon;
  final Function()? clickPassIcon;

  const TexFormFieldBar(
      {super.key,
      this.width,
      this.inputType,
      this.onChanged,
      this.validator,
      this.hintText,
      this.svgIcon,
      this.controller,
      this.haveBorder,
      this.obsecureText,
      this.showPassIcon,
      this.clickPassIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        cursorColor: CustomColor.kindaRed,
        textAlign: TextAlign.left,
        autofocus: false,
        showCursor: true,
        keyboardType: inputType ?? TextInputType.text,
        obscureText: obsecureText ?? false,
        style: TextStyle(
          color: CustomColor.darkColor,
          fontSize: 15.sp,
          fontFamily: CustomFont.medium,
          fontWeight: FontWeight.w500,
        ),
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 14,
          ),
          hintText: hintText ?? "",
          hintStyle: TextStyle(
            color: CustomColor.darkColor.withOpacity(0.5),
            fontSize: 15.sp,
            fontFamily: CustomFont.medium,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: CustomColor.whiteF7,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(
              svgIcon!,
              width: 18.w,
            ),
          ),
          suffixIcon: showPassIcon == true
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: clickPassIcon,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      obsecureText == false ? Asset.hidePass : Asset.showPass,
                      width: 18.w,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: haveBorder == true
                  ? CustomColor.kindaRed
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: haveBorder == true
                  ? CustomColor.kindaRed
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: haveBorder == true
                  ? CustomColor.kindaRed
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
