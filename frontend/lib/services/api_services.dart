import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.brglez.net";

  static Future<Map<String, dynamic>> uploadReceipt(
      String filename, List<int> bytes) async {

    var uri = Uri.parse('$baseUrl/extract/invoice-image');
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Accept": "application/json",
    });

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: filename,
    ));

    print("🚀 Sending request to API...");

    var response = await request.send();

    print("📡 Status code: ${response.statusCode}");

    var responseBody = await response.stream.bytesToString();
    print("📦 Response body: $responseBody");

    if (response.statusCode != 200) {
      throw Exception("Server error: $responseBody");
    }

    return json.decode(responseBody);
  }
}
