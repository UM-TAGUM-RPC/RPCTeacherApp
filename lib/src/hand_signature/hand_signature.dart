import 'dart:developer';
import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

class HandSignatureupload extends ConsumerStatefulWidget {
  const HandSignatureupload({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HandSignatureuploadState();
}

class _HandSignatureuploadState extends ConsumerState<HandSignatureupload> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  void handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void handleSaveButtonPressed() async {
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
        //File('my_image.png').writeAsBytes(bytes.buffer.asUint8List());
        final filePath = "${folder.path}/mySignature.png";
        final file = File(filePath);
        final rag = await file.open(mode: FileMode.writeOnlyAppend);
        rag.writeStringSync("string\n");
        await rag.close();
      } finally {
        final imagepathSignature = '${down.path}/mySignature.png';
        final pathSignature = File(imagepathSignature);
        if (!await pathSignature.exists()) {
          pathSignature.create(recursive: true);
        }
        await pathSignature.writeAsBytes(bytes!.buffer.asUint8List());
        final filePath = "${down.path}/mySignature.png";
        final file = await CRFileSaver.saveFile(filePath,
            destinationFileName: "mySignature");
        log(file.toString(), name: "PATH DONWLOAD");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controller = ref.watch(currentUser);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: Column(
        children: [
          Expanded(
            child: SfSignaturePad(
                key: signatureGlobalKey,
                backgroundColor: Colors.white,
                strokeColor: Colors.black,
                minimumStrokeWidth: 1.0,
                maximumStrokeWidth: 4.0),
          ),
          25.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  handleSaveButtonPressed();
                },
                child: Container(
                  height: 34.63.h,
                  width: 34.63.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColor.kindaRed,
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    Asset.check,
                    width: 12.73.w,
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  handleClearButtonPressed();
                },
                child: Container(
                  height: 34.63.h,
                  width: 34.63.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColor.kindaRed,
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    Asset.clear,
                    width: 12.73.w,
                  )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
