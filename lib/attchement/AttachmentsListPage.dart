import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend_app_stagi/widgets/file_viewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AttachmentsListPage extends StatefulWidget {
  final String studentId;

  AttachmentsListPage({required this.studentId});

  @override
  _AttachmentsListPageState createState() => _AttachmentsListPageState();
}

class _AttachmentsListPageState extends State<AttachmentsListPage> {
  List<dynamic> _attachments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttachments();
  }

  // Récupérer les pièces jointes
  Future<void> _fetchAttachments() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5001/api/attachment/${widget.studentId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _attachments = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des pièces jointes.")),
      );
    }
  }

  void _openAttachment(String filePath) async {
    final url = 'http://10.0.2.2:5001/api/attachment/view/$filePath';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$filePath');

        await tempFile.writeAsBytes(response.bodyBytes);

        if (filePath.endsWith('.pdf')) {
          // Navigate to a PDF viewer page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPage(filePath: tempFile.path),
            ),
          );
        } else {
          OpenFile.open(tempFile.path);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Échec de l'ouverture du fichier.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }



  Future<void> _addAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      setState(() {
        _isLoading = true;
      });

      try {
        final uri = Uri.parse('http://10.0.2.2:5001/api/attachment/upload');
        final request = http.MultipartRequest('POST', uri);

        request.fields['studentId'] = widget.studentId;
        request.files.add(await http.MultipartFile.fromPath('file', filePath));

        final response = await request.send();
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fichier ajouté avec succès.")),
          );
          _fetchAttachments(); // Rafraîchir la liste
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Échec de l'ajout du fichier.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des pièces jointes"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addAttachment, // Ajouter un fichier
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _attachments.length,
        itemBuilder: (context, index) {
          final attachment = _attachments[index];
          return ListTile(
            title: Text(attachment['fileName']),
            subtitle: Text(attachment['fileType']),
            onTap: () => _openAttachment(attachment['fileName']), // Ouvrir un fichier
            trailing: Icon(Icons.file_open),
          );
        },
      ),
    );
  }
}


void main() {
  runApp(
       MaterialApp(
        home: AttachmentsListPage(studentId: '674b810605d7f790d500e23b'),
      ),

  );
}