import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:rpcadvisorapp/global/generate_sheet.dart';

import '../models/models.dart';

final pdfProvider = ChangeNotifierProvider((ref) => PDfProvider());

class PDfProvider extends ChangeNotifier {
  File file = File("");
  List<DateTime> modelList = <DateTime>[];

  Future<void> generate(
      {MonitoringSheet? sheet,
      List<String>? names,
      String? nameteach,
      Function()? onSuccess}) async {
    try {
      if (modelList.isNotEmpty) {
        modelList.clear();
        notifyListeners();
      }
      identify(sheet);
    } finally {
      final pdfFile = await GenerateSheet.generateSheettoPdf(
        name: "${sheet!.thesisTitle}.pdf",
        names: names,
        advisorname: nameteach,
        model: modelList,
      );
      if (pdfFile.path != "") {
        file = pdfFile;

        notifyListeners();
        onSuccess!();
        // final folder = await getTemporaryDirectory();
        // final path = "${folder.path}/${sheet.thesisTitle}.pdf";
        // final files = File(file.path);
        // final rag = await file.open(mode: FileMode.writeOnlyAppend);
        // rag.writeStringSync("string\n");
        // await rag.close();
        final bytes = await pdfFile.readAsBytes();
        await FileSaver.instance.saveAs(
          name: "${sheet.thesisTitle}",
          bytes: bytes,
          fileExtension: "pdf",
          mimeType: MimeType.pdf,
        );
      }
    }
  }

  Future<void> identify(MonitoringSheet? sheet) async {
    if (sheet!.approveTitle == true) {
      modelList.add(sheet.approveTitleDate!);
      notifyListeners();
    }
    if (sheet.outlineProposal == true) {
      modelList.add(sheet.outlineProposalDate!);
      notifyListeners();
    }
    if (sheet.outlineDefense == true) {
      modelList.add(sheet.outlineProposalDate!);
      notifyListeners();
    }
    if (sheet.dataGathering == true) {
      modelList.add(sheet.dataGatheringDate!);
      notifyListeners();
    }
    if (sheet.manuscript == true) {
      modelList.add(sheet.manuscriptDate!);
      notifyListeners();
    }
    if (sheet.finalOralPrep == true) {
      modelList.add(sheet.finalOralPrepDate!);
      notifyListeners();
    }
    if (sheet.routing == true) {
      modelList.add(sheet.routingDate!);
      notifyListeners();
    }
    if (sheet.plagiarism == true) {
      modelList.add(sheet.plagiarismDate!);
      notifyListeners();
    }
    if (sheet.approval == true) {
      modelList.add(sheet.approvalDate!);
      notifyListeners();
    }
    if (sheet.finalOutput == true) {
      modelList.add(sheet.finalOutputDate!);
      notifyListeners();
    }
  }
}
