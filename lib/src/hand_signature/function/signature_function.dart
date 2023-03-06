import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:cr_file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'dart:developer';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as base;

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

final signature =
    AutoDisposeChangeNotifierProvider((ref) => SignatureFunction());

class SignatureFunction extends ChangeNotifier {
  final client = SupaBaseCall.supabaseService;
  var isLoading = false;
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  void handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void handleSaveButtonPressed(
      {String? name, Function()? onSucess, String? advisorSupaId}) async {
    isLoading = true;
    notifyListeners();
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    var down = await getTemporaryDirectory();
    if (!await down.exists()) {
      await down.create(recursive: true);
    }
    if (await down.exists()) {
      try {
        final folder = await getTemporaryDirectory();
        final filePath = "${folder.path}/$name.png";
        final file = File(filePath);
        final rag = await file.open(mode: FileMode.writeOnlyAppend);
        rag.writeStringSync("string\n");
        await rag.close();
      } finally {
        final imagepathSignature = '${down.path}/$name.png';
        final pathSignature = File(imagepathSignature);
        if (!await pathSignature.exists()) {
          pathSignature.create(recursive: true);
        }
        await pathSignature.writeAsBytes(bytes!.buffer.asUint8List());
        final filePath = "${down.path}/$name.png";
        final file =
            await CRFileSaver.saveFile(filePath, destinationFileName: "$name");
        uploadImage(file: File(filePath), advisorSupaID: advisorSupaId);
        log(file.toString(), name: "PATH DONWLOAD");
        isLoading = false;
        notifyListeners();
        onSucess!();
      }
    }
    //uploadImage(file: File(""), advisorSupaID: advisorSupaId);
  }

  uploadImage({File? file, String? advisorSupaID}) async {
    /*
     *
     *  In supabse storage no documentation for existing same file 
     *  So in the end we need to delete if the file path exists
     *  
     */

    try {
      await client.storage
          .from('rpc-bucket')
          .remove([(base.basename(file!.path))]);
    } finally {
      try {
        final url = await client.storage.from("rpc-bucket").upload(
            "${base.basename(file!.path)}/${base.basename(file.path)}", file);
        log("URL $url", name: "Upload url");
      } finally {
        final getUrl = client.storage.from("rpc-bucket").getPublicUrl(
            "${base.basename(file!.path)}/${base.basename(file.path)}");
        final List<dynamic> getdataExist = await client
            .from("advisors_signature")
            .select()
            .eq("advisor_supa_id", advisorSupaID!);
        if (getdataExist.isNotEmpty) {
          // update
          log("Update Advisor Signature");
          await client.from("advisors_signature").update({
            "public_url": getUrl,
          });
        } else {
          // insert
          log("Insert Advisor Signature");
          await client.from("advisors_signature").insert({
            "advisor_supa_id": advisorSupaID,
            "public_url": getUrl,
          });
        }
      }
      /*
       *
       * Identify if data exists 
       *  
      */
    }
  }
}
