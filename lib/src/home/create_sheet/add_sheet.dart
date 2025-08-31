import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rpcadvisorapp/constant/colors.dart';
import 'package:rpcadvisorapp/constant/icons_and_images.dart';
import 'package:rpcadvisorapp/constant/validators.dart';
import 'package:rpcadvisorapp/global/globa_access_data.dart';
import 'package:rpcadvisorapp/src/home/create_sheet/function_sheet.dart';
import 'package:rpcadvisorapp/widget/button/button.dart';
import 'package:rpcadvisorapp/widget/custom_fields/customn_text_field.dart';
import 'package:rpcadvisorapp/widget/dialog/dialog.dart';
import 'package:rpcadvisorapp/widget/text/custom_text.dart';
import 'package:rpcadvisorapp/widget/text/normal_text.dart';

class AddSheetForteacher extends ConsumerStatefulWidget {
  const AddSheetForteacher({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddSheetForteacherState();
}

class _AddSheetForteacherState extends ConsumerState<AddSheetForteacher> {
  TextEditingController title = TextEditingController(),
      code = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> formS = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUser);
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Form(
            key: formS,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomGeneralSans(
                  label1: "M",
                  label2: "onitoring Sheet",
                  fontColor: CustomColor.darkColor,
                  fontSize: 26.sp,
                  bold: true,
                ),
                27.verticalSpace,
                TexFormFieldBar(
                  width: MediaQuery.of(context).size.width,
                  controller: title,
                  svgIcon: Asset.pen,
                  haveBorder: true,
                  hintText: "Title",
                  onChanged: (p0) {},
                  validator: (val) => Validator.emptyField(val),
                ),
                27.verticalSpace,
                TexFormFieldBar(
                  width: MediaQuery.of(context).size.width,
                  controller: code,
                  svgIcon: Asset.codez,
                  haveBorder: true,
                  hintText: "Code",
                  onChanged: (p0) {},
                  validator: (val) => Validator.emptyField(val),
                ),
                15.sp.verticalSpace,
                GeneralSans(
                  label: "STATUS: PENDING",
                  fontSize: 18.sp,
                  bold: true,
                  align: TextAlign.left,
                ),
                41.verticalSpace,
                isLoading == true
                    ? Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            color: CustomColor.kindaRed,
                          ),
                        ),
                      )
                    : Center(
                        child: ButtonRounded(
                          onPressed: () {
                            if (formS.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              FunctionSheet.addSheet(
                                title: title.text,
                                code: code.text,
                                id: profile.user.supabaseId,
                                onError: (s) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  DialogCustom.dialogTemplateSucess(
                                    context: context,
                                    message: s,
                                    press: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  );
                                },
                                onSuccess: (x) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  profile.getCurrentMonitorSheets();
                                },
                              );
                            }
                          },
                          label: "Create",
                          width: 126.w,
                          fontSize: 18.sp,
                          round: 90.0,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
