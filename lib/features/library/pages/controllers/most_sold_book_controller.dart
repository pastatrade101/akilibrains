import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import '../../models/book_model.dart';


class MostSoldBookController extends GetxController {
  static MostSoldBookController get instance => Get.find();

  Future<List<BookModel>> fetchMostSoldBooks() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-rabit-store.cloudfunctions.net/mostBookSold'));

    if (response.statusCode == 200) {
      final List<dynamic> parsedJson = json.decode(response.body);

      return parsedJson.map((json) => BookModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load most sold books');
    }
  }
}
