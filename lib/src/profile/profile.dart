import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/src/auth/signup/function/function_signup.dart';
import 'package:rpcadvisorapp/src/profile/profile_function/function_profile.dart';

import '../../constant/constant.dart';
import '../../global/global.dart';
import '../../widget/widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<FormState> passwordState = GlobalKey<FormState>();

  @override
  void initState() {
    ref
        .read(profileUpdate.notifier)
        .onFirstOpen(ref.read(currentUser.notifier).user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(profileUpdate);
    final showobs = ref.watch(showPass);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 28.0,
              right: 28.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediaQuery.of(context).size.width.horizontalSpace,
                28.verticalSpace,
                TexFormFieldBar(
                  width: 310.w,
                  controller: controller.firstName,
                  svgIcon: Asset.id,
                  hintText: "First Name",
                  onChanged: (p0) {},
                  validator: (val) => Validator.emptyField(val),
                ),
                28.verticalSpace,
                TexFormFieldBar(
                  width: 310.w,
                  controller: controller.lastName,
                  svgIcon: Asset.id,
                  hintText: "Last Name",
                  onChanged: (p0) {},
                  validator: (val) => Validator.emptyField(val),
                ),
                28.verticalSpace,
                TexFormFieldBar(
                  width: 310.w,
                  controller: controller.middleName,
                  svgIcon: Asset.id,
                  hintText: "Middle Name",
                  onChanged: (p0) {},
                  validator: (val) => Validator.emptyField(val),
                ),
                28.verticalSpace,
                TexFormFieldBar(
                  width: 310.w,
                  controller: controller.mobileNumber,
                  svgIcon: Asset.phone,
                  widthIcon: 12.w,
                  hintText: "Mobile Number",
                  onChanged: (p0) {},
                  inputType: TextInputType.number,
                  validator: (val) => Validator.emptyField(val),
                ),
                28.verticalSpace,
                TexFormFieldBar(
                  width: 310.w,
                  controller: controller.idNumber,
                  svgIcon: Asset.id,
                  hintText: "ID Number",
                  onChanged: (p0) {},
                  validator: (val) => Validator.emptyField(val),
                ),
                28.verticalSpace,
                GestureDetector(
                  onTap: () {
                    // log("Still clickable");
                    FocusScope.of(context).unfocus();
                    controller.selectDate(context);
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: TexFormFieldBar(
                      width: 310.w,
                      controller: controller.birth,
                      svgIcon: Asset.id,
                      widthIcon: 12.w,
                      hintText: "Birthday",
                      onChanged: (p0) {},
                      validator: (val) => Validator.emptyField(val),
                    ),
                  ),
                ),
                28.verticalSpace,
                ButtonRounded(
                  label: "Update Profile",
                  onPressed: () {
                    controller.updateprofileadvisor(
                      onSucess: () {
                        DialogCustom.dialogTemplateSucess(
                          context: context,
                          svgIcon: Asset.success,
                          message: "Update Successfully",
                          press: () {
                            context.pop();
                          },
                        );
                      },
                    );
                    ref.read(currentUser.notifier).getUserprofile();
                  },
                  fontColor: CustomColor.white,
                  fontSize: 12.sp,
                  backColor: CustomColor.kindaRed,
                  round: 90,
                  heigth: 36.h,
                  // width: 161.w,
                ),
                15.verticalSpace,
                Divider(
                  color: CustomColor.gray.withOpacity(0.5),
                  thickness: 1,
                ),
                15.verticalSpace,
                Form(
                  key: passwordState,
                  child: Column(
                    children: [
                      TexFormFieldBar(
                        width: 310.w,
                        controller: controller.currentPasswor,
                        svgIcon: Asset.lock,
                        widthIcon: 12.w,
                        hintText: "Current Password",
                        obsecureText: showobs,
                        showPassIcon: true,
                        clickPassIcon: () {
                          ref.read(showPass.notifier).state = !showobs;
                        },
                        onChanged: (p0) {},
                        validator: (val) => Validator.emptyField(val),
                      ),
                      28.verticalSpace,
                      TexFormFieldBar(
                        width: 310.w,
                        controller: controller.password,
                        svgIcon: Asset.lock,
                        hintText: "Password",
                        obsecureText: showobs,
                        widthIcon: 12.w,
                        showPassIcon: true,
                        clickPassIcon: () {
                          ref.read(showPass.notifier).state = !showobs;
                        },
                        onChanged: (p0) {},
                        validator: (val) => Validator.emptyField(val),
                      ),
                      28.verticalSpace,
                      TexFormFieldBar(
                        width: 310.w,
                        controller: controller.confirmpassword,
                        svgIcon: Asset.lock,
                        widthIcon: 12.w,
                        hintText: "Confirm Password",
                        onChanged: (p0) {},
                        clickPassIcon: () {
                          ref.read(showPass.notifier).state = !showobs;
                        },
                        showPassIcon: true,
                        obsecureText: showobs,
                        validator: (val) => Validator.confirmPass(
                          pass1: controller.password.text,
                          pass: val,
                        ),
                      ),
                      28.verticalSpace,
                      ButtonRounded(
                        label: "Update Password",
                        onPressed: () {
                          if (passwordState.currentState!.validate()) {
                            controller.updatepassword(
                              onError: (p0) {
                                DialogCustom.dialogTemplateSucess(
                                  context: context,
                                  svgIcon: Asset.warning,
                                  message: p0,
                                  press: () {
                                    context.pop();
                                  },
                                );
                              },
                              onSucess: () {
                                DialogCustom.dialogTemplateSucess(
                                  context: context,
                                  svgIcon: Asset.success,
                                  message: "Update Password Successfully",
                                  press: () {
                                    context.pop();
                                  },
                                );
                              },
                            );
                          }
                        },
                        fontColor: CustomColor.white,
                        fontSize: 12.sp,
                        backColor: CustomColor.kindaRed,
                        round: 90,
                        heigth: 36.h,
                        // width: 161.w,
                      ),
                      28.verticalSpace,
                    ],
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
