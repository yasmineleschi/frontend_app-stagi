import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerPage extends StatelessWidget {
  final String filePath;

  PDFViewerPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visualiseur PDF")),
      body: PDFView(
        filePath: filePath,
        backgroundColor: Colors.grey,
      ),
    );
  }
}
