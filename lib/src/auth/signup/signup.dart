import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/routes/route_generator.dart';
import 'package:rpcadvisorapp/src/auth/signup/function/function_signup.dart';

import '../../../constant/constant.dart';
import '../../../models/models.dart';
import '../../../widget/widget.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> keysign = GlobalKey<FormState>();

  @override
  void initState() {
    ref.read(signUpController.notifier).getAllListCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showobs = ref.watch(showPass);
    final controller = ref.watch(signUpController);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: keysign,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.goNamed(signIn);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Asset.back,
                            height: 20.h,
                          ),
                          8.horizontalSpace,
                          GeneralSans(
                            label: "Back",
                            fontColor: CustomColor.darkColor,
                            fontSize: 14.sp,
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  21.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomGeneralSans(
                        label1: "S",
                        label2: "ign up",
                        fontColor: CustomColor.darkColor,
                        fontSize: 36.sp,
                        bold: true,
                      ),
                      8.horizontalSpace,
                      SvgPicture.asset(
                        Asset.person,
                        height: 24.h,
                      ),
                    ],
                  ),
                  17.verticalSpace,
                  Center(
                    child: SizedBox(
                      width: 195.w,
                      child: Divider(
                        thickness: 1,
                        color: CustomColor.gray.withOpacity(0.5),
                      ),
                    ),
                  ),
                  35.verticalSpace,
                  TexFormFieldBar(
                    width: 310.w,
                    controller: controller.email,
                    svgIcon: Asset.emailIcon,
                    hintText: "Email",
                    onChanged: (p0) {},
                    validator: (val) => Validator.emptyField(val),
                  ),
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
                  DropdownSearch<Course>(
                    dropdownBuilder: (context, selectedItem) {
                      return GeneralSans(
                        label: selectedItem!.courseDepartment ??
                            "Search Course Department",
                        fontColor: CustomColor.darkColor,
                        fontSize: 15.sp,
                        medium: true,
                        //bold: true,
                        align: TextAlign.left,
                      );
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                        hintText: "Search Department",
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
                            Asset.search,
                            width: 12.w,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    selectedItem: controller.currentSelected,
                    items: controller.state,
                    itemAsString: (item) => item.courseDepartment!,
                    popupProps: PopupProps.dialog(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(
                          color: CustomColor.darkColor,
                          fontSize: 12.sp,
                          fontFamily: CustomFont.bold,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 14,
                          ),
                          hintText: "Search Department",
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
                              Asset.search,
                              width: 12.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GeneralSans(
                          label: item.courseDepartment,
                          fontColor: CustomColor.darkColor,
                          fontSize: 15.sp,
                          medium: true,
                          align: TextAlign.left,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      // createAccount.courseCurrentHolder = value!;
                      controller.selectedItem(value);
                    },
                    validator: (value) {
                      if (controller.currentSelected == Course()) {
                        return "Empty Course";
                      } else {
                        return null;
                      }
                    },
                  ),
                  28.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      log("Still clickable");
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
                  TexFormFieldBar(
                    width: 310.w,
                    controller: controller.password1,
                    svgIcon: Asset.id,
                    hintText: "Password",
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
                    controller: controller.password2,
                    svgIcon: Asset.id,
                    widthIcon: 12.w,
                    hintText: "Confirm Password",
                    onChanged: (p0) {},
                    clickPassIcon: () {
                      ref.read(showPass.notifier).state = !showobs;
                    },
                    showPassIcon: true,
                    obsecureText: showobs,
                    validator: (val) => Validator.confirmPass(
                      pass1: controller.password1.text,
                      pass: val,
                    ),
                  ),
                  28.verticalSpace,
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
                              //  if (keysign.currentState!.validate()) {
                              controller.signupNow(context: context);
                              // }
                              // ref.read(authidentifier.notifier).signIn();
                            },
                            label: "Sign up",
                            width: 126.w,
                            fontSize: 18.sp,
                            round: 90.0,
                          ),
                        ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
