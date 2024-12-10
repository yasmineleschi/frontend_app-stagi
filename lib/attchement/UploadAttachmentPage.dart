import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadAttachmentPage extends StatefulWidget {
  @override
  _UploadAttachmentPageState createState() => _UploadAttachmentPageState();
}

class _UploadAttachmentPageState extends State<UploadAttachmentPage> {
  String? _selectedFile;
  String? studentId;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.path!;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null || studentId == null || studentId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez sélectionner un fichier et entrer un ID étudiant.")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final uri = Uri.parse('http://10.0.2.2:5001/api/attachment/upload');
    final request = http.MultipartRequest('POST', uri);

    request.fields['studentId'] = studentId!;
    request.files.add(await http.MultipartFile.fromPath('file', _selectedFile!));

    final response = await request.send();

    setState(() {
      _isUploading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fichier téléchargé avec succès.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec du téléchargement.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Télécharger une pièce jointe")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "ID étudiant"),
              onChanged: (value) => studentId = value,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text("Choisir un fichier"),
            ),
            SizedBox(height: 8),
            Text(_selectedFile ?? "Aucun fichier sélectionné"),
            SizedBox(height: 16),
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _uploadFile,
              child: Text("Télécharger"),
            ),
          ],
        ),
      ),
    );
  }
}
