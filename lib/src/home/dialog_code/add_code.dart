import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rpcadvisorapp/constant/constant.dart';

import '../../../global/global.dart';
import '../../../widget/widget.dart';

class AddCodeAdvisor extends ConsumerStatefulWidget {
  const AddCodeAdvisor({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCodeAdvisorState();
}

class _AddCodeAdvisorState extends ConsumerState<AddCodeAdvisor> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUser);
    return Dialog(
      elevation: 0,
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
              padding: const EdgeInsets.all(26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GeneralSans(
                    label: "Enter Code:",
                    fontColor: CustomColor.darkColor,
                    fontSize: 12.sp,
                    semiBold: true,
                  ),
                  10.verticalSpace,
                  TexFormFieldBar(
                    width: 310.w,
                    controller: profile.enterCode,
                    svgIcon: Asset.codez,
                    hintText: "Enter Code",
                    onChanged: (p0) {},
                    validator: (val) => Validator.emptyField(val),
                  ),
                  25.verticalSpace,
                  Center(
                    child: ButtonRounded(
                      onPressed: () {
                        profile.enterCodeAdvisor();
                      },
                      label: "Submit",
                      width: 100.w,
                      heigth: 40.h,
                      fontSize: 15.sp,
                      round: 5.0,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
