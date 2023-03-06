import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'package:rpcadvisorapp/src/hand_signature/function/signature_function.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../global/global.dart';
import '../../widget/widget.dart';

class HandSignatureupload extends ConsumerStatefulWidget {
  const HandSignatureupload({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HandSignatureuploadState();
}

class _HandSignatureuploadState extends ConsumerState<HandSignatureupload> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(currentUser);
    final sfisignature = ref.watch(signature);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: Column(
        children: [
          Expanded(
            child: SfSignaturePad(
                key: sfisignature.signatureGlobalKey,
                backgroundColor: Colors.white,
                strokeColor: Colors.black,
                minimumStrokeWidth: 1.0,
                maximumStrokeWidth: 4.0),
          ),
          25.verticalSpace,
          sfisignature.isLoading == true
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        color: CustomColor.kindaRed,
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        sfisignature.handleSaveButtonPressed(
                            name:
                                "${controller.user!.firstName!}-${controller.user!.lastName!}",
                            advisorSupaId: controller.user!.supabaseId,
                            onSucess: () {
                              DialogCustom.dialogTemplateSucess(
                                context: context,
                                svgIcon: Asset.success,
                                message:
                                    "Signature Successfully Upload and Save to Downloads Folder as a copy",
                                press: () {
                                  context.pop();
                                  sfisignature.handleClearButtonPressed();
                                },
                              );
                            });
                      },
                      child: Container(
                        height: 34.63.h,
                        width: 34.63.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColor.kindaRed,
                        ),
                        child: Center(
                            child: SvgPicture.asset(
                          Asset.check,
                          width: 12.73.w,
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sfisignature.handleClearButtonPressed();
                      },
                      child: Container(
                        height: 34.63.h,
                        width: 34.63.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColor.kindaRed,
                        ),
                        child: Center(
                            child: SvgPicture.asset(
                          Asset.clear,
                          width: 12.73.w,
                        )),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
