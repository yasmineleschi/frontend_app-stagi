import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/attachment_model.dart';

class AttachmentService {
  final String baseUrl = "http://10.0.2.2:5001/api/attachment";


  Future<AttachmentModel?> uploadAttachment(String studentId, File file) async {
    try {

      final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload"));
      request.fields['studentId'] = studentId;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.path.split('/').last,
      ));


      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);


      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return AttachmentModel.fromJson(responseData['attachment']);
      } else {
        print("Failed to upload file: ${response.body}");
        throw Exception("Failed to upload file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in uploadAttachment: $e");
      return null;
    }
  }


  Future<List<AttachmentModel>> getAttachments(String studentId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((e) => AttachmentModel.fromJson(e)).toList();
      } else {
        print("Failed to fetch attachments: ${response.body}");
        throw Exception("Failed to fetch attachments. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching attachments: $e");
      throw Exception("Error fetching attachments: $e");
    }
  }
}
