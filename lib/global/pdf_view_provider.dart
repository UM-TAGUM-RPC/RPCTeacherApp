import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpcadvisorapp/global/generate_sheet.dart';

import '../models/monitoring_sheet.dart';

final pdfProvider = ChangeNotifierProvider((ref) => PDfProvider());

class PDfProvider extends ChangeNotifier {
  File file = File("");

  generate(
      {MonitoringSheet? sheet,
      //List<ModelSignature>? model,
      List<String>? names,
      String? nameteach,
      Function()? onSuccess}) async {
    //final List<String> names = <String>[];
    // try {

    //   // for (var x in sheet!.idStudent!.studentsId!) {
    //   //   final namesAdded = returnStudentName(id: x.idStudent);
    //   //   names.add(namesAdded);
    //   //   notifyListeners();
    //   // }
    // } finally {
    // if (names.isNotEmpty) {
    final pdfFile = await GenerateSheet.generateSheettoPdf(
      name: "${sheet!.thesisTitle}.pdf",
      names: names,
      // model: model,
      advisorname: nameteach,
    );
    if (pdfFile.path != "") {
      file = pdfFile;
      notifyListeners();
      onSuccess!();
    }
    // }
    //}
  }
}
