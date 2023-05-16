import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rpcadvisorapp/global/auth_global.dart';
import 'package:rpcadvisorapp/routes/route_generator.dart';

import '../../../constant/constant.dart';
import '../../../widget/widget.dart';

final obsecure = AutoDisposeStateProvider((ref) => true);

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController email = TextEditingController(),
      password = TextEditingController();
  final GlobalKey<FormState> keysignIn = GlobalKey<FormState>();

  @override
  void initState() {
    allowStorage();
    ref.read(authidentifier.notifier).statusUserAunthenticated();
    super.initState();
  }

  allowStorage() async {
    await [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.photos
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    final obse = ref.watch(obsecure);
    final controller = ref.watch(authidentifier);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 33,
            right: 33,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: keysignIn,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  67.verticalSpace,
                  CustomGeneralSans(
                    label1: "W",
                    label2: "elcome",
                    fontColor: CustomColor.darkColor,
                    fontSize: 48.sp,
                    bold: true,
                  ),
                  GeneralSans(
                    label:
                        "to Research and Publication Center\nAdvisor/Teacher’s App",
                    fontSize: 18.sp,
                    align: TextAlign.left,
                  ),
                  40.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: SizedBox(
                      width: 460.w,
                      child: Divider(
                        color: CustomColor.darkColor.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                  ),
                  22.verticalSpace,
                  CustomGeneralSans(
                    label1: "S",
                    label2: "ign in",
                    fontColor: CustomColor.darkColor,
                    fontSize: 36.sp,
                    bold: true,
                  ),
                  27.verticalSpace,
                  TexFormFieldBar(
                    width: 310.w,
                    controller: email,
                    svgIcon: Asset.emailIcon,
                    haveBorder: true,
                    hintText: "Email",
                    onChanged: (p0) {},
                    validator: (val) => Validator.emptyField(val),
                  ),
                  41.verticalSpace,
                  TexFormFieldBar(
                    width: 310.w,
                    haveBorder: true,
                    controller: password,
                    svgIcon: Asset.passwordIcon,
                    obsecureText: obse,
                    hintText: "Password",
                    showPassIcon: true,
                    onChanged: (p0) {},
                    validator: (val) => Validator.emptyField(val),
                    clickPassIcon: () {
                      ref.read(obsecure.notifier).state = !obse;
                    },
                  ),
                  27.verticalSpace,
                  controller.isLoading == true
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: CustomColor.kindaRed,
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerRight,
                          child: ButtonRounded(
                            onPressed: () {
                              if (keysignIn.currentState!.validate()) {
                                ref.read(authidentifier.notifier).signIn(
                                      onError: (p0) {
                                        DialogCustom.dialogTemplateSucess(
                                          context: context,
                                          message: p0,
                                          press: () {
                                            context.pop();
                                          },
                                        );
                                      },
                                      email: email.text,
                                      password: password.text,
                                    );
                              }
                            },
                            label: "Sign In",
                            width: 126.w,
                            fontSize: 18.sp,
                            round: 90.0,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              context.goNamed(signup);
            },
            behavior: HitTestBehavior.translucent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GeneralSans(
                  label: "Don't have an account Yet? ",
                  fontSize: 11.sp,
                  align: TextAlign.left,
                ),
                GeneralSans(
                  label: "Sign up now.",
                  fontSize: 11.sp,
                  align: TextAlign.left,
                  bold: true,
                  fontColor: CustomColor.kindaRed,
                ),
              ],
            ),
          ),
          18.verticalSpace,
          GeneralSans(
            label: "Build version: Development 1",
            fontSize: 8.sp,
            align: TextAlign.left,
          ),
          11.verticalSpace,
        ],
      ),
    );
  }
}
