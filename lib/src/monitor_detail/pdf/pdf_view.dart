import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../constant/constant.dart';
import '../../../global/pdf_view_provider.dart';

class PdfView extends ConsumerStatefulWidget {
  const PdfView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfViewState();
}

class _PdfViewState extends ConsumerState<PdfView> {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final pdf = ref.watch(pdfProvider);
    return Scaffold(
      backgroundColor: CustomColor.white,
      appBar: AppBar(
        title: const Text('PDF VIEW'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,  
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: RotatedBox(
        quarterTurns: 2,
        child: SfPdfViewer.file(
          pdf.file,
          key: pdfViewerKey,
        ),
      ),
    );
  }
}
