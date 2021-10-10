import 'dart:convert';
import 'dart:developer';

import 'package:cm/models/issue.dart';
import 'package:http/http.dart' as http;

abstract class Api {
  static final _baseUrl = 'https://peaceful-cove-23510.herokuapp.com';
  static String _token = '\$2a\$10\$CccxA4qkQstn8TUTXWuhfOjNoHBTBVEdaNoolJXcTDmV5miR1LdfG';

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
    print(response.body);

    var respObject = jsonDecode(response.body);
    if (respObject != null && respObject.containsKey('payload')) {
      print(respObject);
      if (respObject['payload'] != null) {
        if (respObject['payload'].containsKey('identifier')) {
          _token = respObject['payload']['identifier'];
          print("token obtained: $_token");
        }
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
        "email": "1unknown@unknown.unknown",
        "firstName": "Неизвестно",
        "lastName": "Неизвестно",
        "phone": phone,
        "password": password,
      }),
    );
    return response;
  }

  static Future<List<Issue>> getAllIssues() async {
    var response = await http.get(
      Uri.parse('$_baseUrl/client/issues'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _token,
      },
    );
    var toJsonObject = (String s) {
      var l = s.runes.toList();
      return json.decode(utf8.decode(l));
    };
    var respObj = toJsonObject(response.body);
    List<Issue> issues = [];
    for (var obj in respObj) {
      issues.add(Issue(
        title: obj['title'],
        content: obj['content'],
        status: obj['status'],
      ));
    }
    return issues;
  }

  static Future<http.Response> createIssue({String title, String content}) async {
    var response = await http.post(
      Uri.parse('$_baseUrl/client/issue'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _token,
      },
      body: jsonEncode(<String, dynamic>{
        "title": title,
        "content": content,
        "longitude": 45.8345823758,
        "latitude": 45.8345823758,
        "address": "Улица спортивная 114",
        "photos": [
          {
            "url": "фотка ямы",
          },
        ]
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
