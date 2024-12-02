import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/attachment_model.dart';

class AttachmentService {
  final String baseUrl = "http://10.0.2.2:5001/api/attachment";

  Future<AttachmentModel> uploadAttachment(File file, String studentId) async {
    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload"))
      ..fields['studentId'] = studentId
      ..files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      return AttachmentModel.fromJson(responseData);
    } else {
      throw Exception("Failed to upload attachment");
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
      throw Exception("Error fetching attachments: $e");
    }
  }
}
