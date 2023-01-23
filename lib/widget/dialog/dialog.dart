import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/constant.dart';
import '../widget.dart';

class DialogCustom {
  static dialogTemplateSucess({
    BuildContext? context,
    String? message,
    Function()? press,
  }) {
    showGeneralDialog(
        context: context!,
        barrierColor: const Color(0xFF1A1919).withOpacity(0.3),
        barrierDismissible: true,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 360),
        transitionBuilder: (c, a, s, ch) {
          return Transform.scale(
            scale: a.value,
            child: Opacity(
              opacity: a.value,
              child: Dialog(
                // elevation: 1,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 299.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(46.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Asset.warning,
                                height: 74.h,
                              ),
                              18.verticalSpace,
                              GeneralSans(
                                label: message ?? "",
                                fontSize: 20.sp,
                                fontColor: CustomColor.darkColor,
                                align: TextAlign.center,
                                bold: true,
                              ),
                              28.verticalSpace,
                              ButtonRounded(
                                label: "Close",
                                onPressed: press,
                                fontColor: CustomColor.white,
                                fontSize: 12.sp,
                                backColor: CustomColor.kindaRed,
                                round: 90,
                                heigth: 36.h,
                                width: 161.w,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        },
        pageBuilder: (c, r, x0) {
          return const SizedBox.shrink();
        });
  }
}
