class Validator {
  static String? emptyField(String? val) {
    if (val!.isEmpty) {
      return "Required Field";
    } else {
      return null;
    }
  }

  static String? validatenumber(String? input) {
    RegExp regExp = RegExp(r'^(09)[0-9]{9}$');

    if (input!.isEmpty || input == "0") {
      return "Don't leave blank";
    } else if (regExp.hasMatch(input)) {
      return null;
    } else {
      return "Mobile number not formatted";
    }
  }
}
