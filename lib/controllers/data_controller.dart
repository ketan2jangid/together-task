import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/data_model.dart';

const baseUrl = 'https://mock.together.buzz/mocks/discovery';

class DataController {
  List<DataModel> data = [];
  bool listEnd = false;

  Future<({bool success, String msg})> fetchData(
      {int? pageKey, int? limit}) async {
    try {
      // log('calling');
      final http.Response res = await http
          .get(Uri.parse('$baseUrl?page=${pageKey ?? 1}&limit=${limit ?? 10}'));

      // log('resp');
      if (res.statusCode != 200) {
        // error = res.body;

        // log(res.statusCode.toString());
        return (success: false, msg: statusToMsg[res.statusCode].toString());
      }
      final Map<String, dynamic> json = jsonDecode(res.body);

      int newData = 0;
      json['data'].forEach((val) {
        newData++;
        data.add(DataModel.fromJson(val));
      });

      if (newData < (limit ?? 10)) {
        listEnd = true;

        // log(newData.toString() + '  ' + listEnd.toString());
      }

      // log(json.toString());

      return (success: true, msg: "");
    } catch (err) {
      // log("Error - " + err.toString());

      return (success: false, msg: "Something went wrong");
    }
  }
}

Map<int, String> statusToMsg = {
  400: 'Bad request',
  401: 'Authenticate to see result',
  403: 'You are not authorized',
  404: 'Resource not found',
  408: 'Request timeout',
  500: 'Internal server error',
  502: 'Bad gateway',
  503: 'Service unavailable',
};
