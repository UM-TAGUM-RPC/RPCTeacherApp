import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rpcadvisorapp/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constant/constant.dart';

final profileUpdate =
    AutoDisposeChangeNotifierProvider((ref) => ProfileUpdate());

class ProfileUpdate extends ChangeNotifier {
  bool isLoading = false;
  DateTime birthSelected = DateTime.now();
  final formatDate = DateFormat("dd-MM-yyyy");
  final base = SupaBaseCall.supabaseService;
  onFirstOpen(UsersModel? user) {
    firstName.text = user!.firstName!;
    lastName.text = user.lastName!;
    middleName.text = user.middleName!;
    mobileNumber.text = user.mobileNumber!;
    idNumber.text = user.idNumber!;
    birth.text = user.birth!;
  }

  TextEditingController firstName = TextEditingController(),
      lastName = TextEditingController(),
      middleName = TextEditingController(),
      mobileNumber = TextEditingController(),
      idNumber = TextEditingController(),
      birth = TextEditingController(),
      currentPasswor = TextEditingController(),
      password = TextEditingController(),
      confirmpassword = TextEditingController();
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

  updateprofileadvisor({void Function()? onSucess}) async {
    await base.from("users").update({
      "idNumber": idNumber.text,
      "firstName": firstName.text,
      "lastName": lastName.text,
      "middleName": middleName.text,
      "mobileNumber": mobileNumber.text,
      "birth": birth.text
    }).eq("supabase_id", base.auth.currentUser!.id);
    onSucess!();
  }

  updatepassword(
      {void Function(String)? onError, void Function()? onSucess}) async {
    final currentPassExact = await base
        .from("users")
        .select()
        .eq("supabase_id", base.auth.currentUser!.id)
        .single();
    final user = UsersModel.fromJson(currentPassExact);
    if (user.passwordCopy == currentPasswor.text) {
      await base.auth.updateUser(
        UserAttributes(
          password: password.text,
        ),
      );
      onSucess!();
    } else {
      onError!("Current Password not Match on our Database");
    }
  }
}
