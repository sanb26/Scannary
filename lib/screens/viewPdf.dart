import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class viewPdf extends StatelessWidget {
  final PDFDocument doc;
  const viewPdf({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),

      body: Center(
        child: PDFViewer(document: doc),
      )
    );
  }
}
