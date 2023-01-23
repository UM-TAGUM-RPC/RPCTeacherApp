import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'package:rpcadvisorapp/routes/route_generator.dart';
import 'package:rpcadvisorapp/widget/widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../models/models.dart';

final showPass = AutoDisposeStateProvider((ref) => true);

final signUpController = ChangeNotifierProvider<SignUpFunction>((ref) {
  return SignUpFunction();
});

class SignUpFunction extends ChangeNotifier {
  final base = SupaBaseCall.supabaseService;
  bool isLoading = false;
  final TextEditingController email = TextEditingController(),
      firstName = TextEditingController(),
      lastName = TextEditingController(),
      middleName = TextEditingController(),
      mobileNumber = TextEditingController(),
      idNumber = TextEditingController(),
      birth = TextEditingController(),
      password1 = TextEditingController(),
      password2 = TextEditingController();

  List<Course> state = <Course>[];
  Course currentSelected = Course();
  DateTime birthSelected = DateTime.now();
  final formatDate = DateFormat("dd-MM-yyyy");

  getAllListCourse() async {
    final List<dynamic> list = await base.from("courses").select();
    log(list.map((e) => Course.fromJson(e)).toList().toString(),
        name: "COURSES");
    state = [...list.map((e) => Course.fromJson(e)).toList()];
    notifyListeners();
  }

  selectedItem(Course? c) {
    currentSelected = c!;
    notifyListeners();
  }

  selectDate(context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: birthSelected,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );
    if (date != null) {
      birthSelected = date;
      log(formatDate.format(birthSelected));
      birth.text = formatDate.format(birthSelected);
      notifyListeners();
    }
  }

  void clearAll() {
    idNumber.text = "";
    firstName.text = "";
    lastName.text = "";
    middleName.text = "";
    email.text = "";
    mobileNumber.text = "";
    birth.text = "";
    password1.text = "";
    currentSelected = Course();
    isLoading = false;
    notifyListeners();
  }

  signupNow({context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final haveData = await base
          .from("users")
          .select()
          .eq("idNumber", idNumber.text)
          .single();

      if (haveData != {}) {
        log("Can go here error");
        isLoading = false;
        DialogCustom.dialogTemplateSucess(
          context: context,
          message: "ID Number already existed.",
          press: () {
            GoRouter.of(context).pop();
          },
        );
      }
    } on PostgrestException catch (e) {
      log("Can go here ${e.message}");
      try {
        final createAccount = await base.auth.signUp(
          password: password1.text,
          email: email.text,
        );
        log("Signing email process");
        if (createAccount.user!.id != "") {
          log("Signing email process sucess");
          try {
            await base.from("users").insert({
              "idNumber": idNumber.text,
              "email": email.text,
              "confirmationCode": "NONE",
              "firstName": firstName.text,
              "lastName": lastName.text,
              "middleName": middleName.text,
              "mobileNumber": mobileNumber.text,
              "birth": birth.text,
              "passwordCopy": password1.text,
              "role": "Advisor",
              "supabase_id": createAccount.user!.id,
              "active": false,
            }).then((value) async {
              log("Signing user process sucess");
              await base.from("user_department").insert({
                "id_number": idNumber.text,
                "supabase_id": createAccount.user!.id,
                "course_id": currentSelected.id,
              }).whenComplete(
                () {
                  log("Signing user department process sucess");
                  clearAll();
                  GoRouter.of(context).goNamed(signIn);
                },
              );
            });
          } on PostgrestException catch (e) {
            DialogCustom.dialogTemplateSucess(
              context: context,
              message: e.message,
              press: () {
                GoRouter.of(context).pop();
              },
            );
          }
        }
      } on AuthException catch (e) {
        DialogCustom.dialogTemplateSucess(
          context: context,
          message: e.message,
          press: () {
            GoRouter.of(context).pop();
          },
        );
      }
    }
  }
}
