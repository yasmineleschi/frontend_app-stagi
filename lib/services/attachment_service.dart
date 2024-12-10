import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/attachment_model.dart';

class AttachmentService {
  final String baseUrl = "http://localhost:5001/api/attachment";

  Future<void> uploadAttachment(File file, String studentId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'),
      );

      request.fields['studentId'] = studentId;
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ),
      );

      request.headers.addAll({'Accept': 'application/json'});

      final response = await request.send();
      if (response.statusCode != 201) {
        final error = await response.stream.bytesToString();
        throw Exception('Erreur : $error');
      }
    } catch (e) {
      print('Erreur lors de l\'upload : $e');
      throw Exception('Erreur lors de l\'upload : $e');
    }
  }

  Future<List<AttachmentModel>> getAttachments(String studentId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((e) => AttachmentModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch attachments. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching attachments: $e');
      throw Exception('Error fetching attachments: $e');
    }
  }

  Future<File> viewAttachment(String filename) async {
    try {
      final url = Uri.parse('$baseUrl/view/$filename');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Save the file locally
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$filename';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception("Failed to view attachment. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error viewing attachment: $e');
      throw Exception('Error viewing attachment: $e');
    }
  }
}
