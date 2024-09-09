import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<dynamic>> fetchData(int start, int limit) async {
    final response = await http.get(Uri.parse('$apiUrl?_start=$start&_limit=$limit'));

    log('Body : ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }else {
      throw Exception("Failed to fetch data from API");
    }
  }
}
