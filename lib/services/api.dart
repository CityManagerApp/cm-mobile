import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Api {

  static final _baseUrl = 'https://peaceful-cove-23510.herokuapp.com';
  static String _token = 'unknown';


  static Future<http.Response> login({String phone, String password}) async {
    var response = await http.post(
      Uri.parse('$_baseUrl/client/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "phoneNumber": phone,
        "password": password,
      }),
    );
    var respObject = jsonDecode(response.body);
    if (respObject.containsKey('payload')) {
      if (respObject['payload'].containsKey('identifier')) {
        _token = respObject['payload']['identifier'];
        print("token obtained: $_token");
      }
    }
    return response;
  }


  static Future<http.Response> signUp({String phone, String password}) async {
    var response = await http.post(
      Uri.parse('$_baseUrl/client/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "cityId": 0,
        "email": "unknown@unknown.unknown",
        "firstName": "Неизвестно",
        "lastName": "Неизвестно",
        "phone": "+79518977157",
        "password": password,
      }),
    );
    return response;
  }


  static bool noErrors(http.Response response) {
    var respObject = jsonDecode(response.body);
    if (respObject.containsKey('error')) {
      if (!(respObject['error'] == null)) {
        return false;
      }
    }
    return true;
  }

}
