import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../models/models.dart';

class GenerateSheet {
  static Future<File> saveDocumentPdf({
    String? name,
    pw.Document? document,
  }) async {
    final bytes = await document!.save();
    final dir = await getTemporaryDirectory();
    // final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<File> generateSheettoPdf(
      {String? name,
      List<String>? names,
      MonitoringSheet? sheet,
      //List<ModelSignature>? model,
      String? advisorname}) async {
    final pdf = pw.Document();
    final netImage = await networkImage(
        "https://res.cloudinary.com/dfnvlnlzi/image/upload/v1678266482/UMLOGO/um_ucq8ij.png");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.landscape,
        build: (context) => [
          buildStaticheader(
            image: netImage,
          ),
          pw.SizedBox(height: 8),
          buildBody(
            sheet: sheet,
            //model: model,
            names: names,
          ),
          pw.SizedBox(height: 25),
          buildFooter(name: advisorname),
        ],
      ),
    );

    return saveDocumentPdf(name: name, document: pdf);
  }

  /*
   * 
   * Header UM 
   * 
   */
  static Widget buildStaticheader({ImageProvider? image}) => Row(
        children: [
          Container(
            height: 60.h,
            width: 120.w,
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.black, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: pw.Image(image!),
              ),
            ),
          ),
          pw.SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: PdfColors.black, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          generalSans(
                            bold: true,
                            label: "RESEARCH AND PUBLICATION CENTER",
                            align: TextAlign.center,
                            fontSize: 12.sp,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  generalSans(
                                    bold: true,
                                    label: "[  ]",
                                    align: TextAlign.center,
                                    fontSize: 7.sp,
                                  ),
                                  pw.SizedBox(width: 10),
                                  generalSans(
                                    label: "Main",
                                    align: TextAlign.center,
                                    fontSize: 7.sp,
                                  ),
                                ],
                              ),
                              pw.SizedBox(width: 15),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  generalSans(
                                    bold: true,
                                    label: "[  ]",
                                    align: TextAlign.center,
                                    fontSize: 7.sp,
                                  ),
                                  pw.SizedBox(width: 10),
                                  generalSans(
                                    label: "Branch",
                                    align: TextAlign.center,
                                    fontSize: 7.sp,
                                  ),
                                ],
                              ),
                              pw.SizedBox(width: 5),
                              Container(
                                width: 90.w,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: PdfColors.black,
                                ))),
                                child: Center(
                                  child: generalSans(
                                    label: "TAGUM",
                                    align: TextAlign.center,
                                    fontSize: 7.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: PdfColors.black,
                  ),
                  // Divider(
                  //   thickness: 2,
                  //   color: PdfColors.black,
                  // ),
                  SizedBox(
                    height: 3,
                  ),
                  pw.Center(
                    child: generalSans(
                      bold: true,
                      label: "MONITORING SHEET FOR UNDERGRADUATE RESEARCH",
                      align: TextAlign.center,
                      fontSize: 10.sp,
                      fontColor: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  /*
   * 
   * Body UM 
   * 
   */

  /*
   * 
   * Table Body Header 
   * 
   */

  static TableRow headertableBody() {
    final header = [
      "Proponents",
      "Approval\nof Tilte",
      "Outline\nProposal",
      "Outline\nDefense",
      "Data\nGathering",
      "Manuscript\nfor Oral\nPresentation",
      "Final Oral\nPresentation",
      "Routing",
      "Plagiarism\nCheck",
      "Approval",
      "Submission of Approved\nFinal Output\n(Book Form)"
    ];

    return TableRow(
        decoration: const BoxDecoration(
          color: PdfColors.grey200,
        ),
        verticalAlignment: TableCellVerticalAlignment.middle,
        children: header
            .map(
              (e) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  child: SizedBox(
                    height: 30,
                    width: e == "Proponents" ? 100.w : null,
                    child: Center(
                      child: generalSans(
                        label: e,
                        align: TextAlign.center,
                        fontSize: 8.sp,
                        bold: true,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }

  /*
   * 
   * Body Um data
   * 
   */

  static List<TableRow> bodydataOfUser({
    // List<ModelSignature>? model,
    List<String>? names,
  }) {
    final listRow = <TableRow>[
      headertableBody(),
    ];

    try {
      for (var x in names!) {
        // for (var y in model!) {
        final nameStudent = x;
        listRow.add(
          TableRow(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 2,
                ),
                child: SizedBox(
                  height: 11,
                  width: null,
                  child: Center(
                    child: generalSans(
                      label: nameStudent,
                      align: TextAlign.center,
                      fontSize: 7.sp,
                    ),
                  ),
                ),
              ),
            ),
            // ...model!
            //     .map(
            //       (e) => Center(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //             vertical: 2,
            //             horizontal: 2,
            //           ),
            //           child: SizedBox(
            //             height: 11,
            //             width: null,
            //             child: Align(
            //               alignment: Alignment.bottomCenter,
            //               child: generalSans(
            //                 label: DateFormat("yyyy-MM-dd").format(e.date!),
            //                 align: TextAlign.center,
            //                 fontSize: 7.sp,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     )
            //     .toList()
          ]),
        );
      }
    } finally {
      if (listRow.length != 24) {
        final count = 24 - listRow.length;
        for (int x = 0; listRow.length < count; x++) {
          listRow.add(TableRow(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 2,
                ),
                child: SizedBox(
                  height: 11,
                  width: null,
                  child: Center(
                    child: generalSans(
                      label: "",
                      align: TextAlign.center,
                      fontSize: 7.sp,
                    ),
                  ),
                ),
              ),
            ),
          ]));
        }
      }
    }

    //  for (int x = 0; x < 22; x++) {
    //   log(x.toString());
    // }

    return listRow;
  }

  static Widget buildBody({
    MonitoringSheet? sheet,
    // List<ModelSignature>? model,
    List<String>? names,
  }) {
    return Table(
      border: TableBorder.all(
        color: PdfColors.black,
        width: 2,
      ),
      children: bodydataOfUser(
        //model: model,
        names: names,
      ),
      // [

      //   bodydataOfUser(
      //     model: model,
      //     names: names,
      //   ),
      // ],
    );
  }

  /*
   * 
   * Footer UM
   * 
   */

  static Widget buildFooter({String? name}) {
    return Column(children: [
      Row(children: [
        generalSans(
          label: "Submitted by:",
          align: TextAlign.center,
          fontSize: 8.sp,
        ),
        SizedBox(
          width: 5,
        ),
        Column(children: [
          SizedBox(
            width: 110.w,
            height: 15,
            child: generalSans(
                label: name ?? "",
                align: TextAlign.center,
                fontSize: 8.sp,
                bold: true),
          ),
          Container(
            width: 110.w,
            height: 2,
            color: PdfColors.black,
          ),
          generalSans(
            label: "Subject Teacher",
            align: TextAlign.center,
            fontSize: 8.sp,
          ),
        ]),
        Spacer(),
        Row(children: [
          generalSans(
            label: "Noted by:",
            align: TextAlign.center,
            fontSize: 8.sp,
          ),
          SizedBox(
            width: 5,
          ),
          Column(children: [
            SizedBox(
              width: 120.w,
              height: 15,
              child: generalSans(
                  label: "LARCYNEIL P. PASCUAL, PHD",
                  align: TextAlign.center,
                  fontSize: 8.sp,
                  bold: true),
            ),
            Container(
              width: 110.w,
              height: 2,
              color: PdfColors.black,
            ),
            generalSans(
              label: "Research Coordinator",
              align: TextAlign.center,
              fontSize: 8.sp,
            ),
          ]),
        ])
      ]),
      // SizedBox(
      //   height: 2,
      // ),
      // generalSans(
      //   label: "F-13100-20 / Rev.# 0/ Effectivity: January 25, 2018 ",
      //   align: TextAlign.center,
      //   fontSize: 12.spMax,
      // ),
    ]);
  }

  /*
   * 
   * General Sans
   * 
   */

  static generalSans({
    String? label,
    TextAlign? align,
    bool? bold,
    double? fontSize,
    PdfColor? fontColor,
  }) {
    return pw.Text(
      label ?? "",
      maxLines: 100,
      textAlign: align ?? TextAlign.center,
      style: pw.TextStyle(
        fontSize: fontSize ?? 15,
        font: bold == true ? pw.Font.helveticaBold() : pw.Font.helvetica(),
        fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
