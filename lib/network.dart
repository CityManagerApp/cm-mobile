import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

Timer setTimeout(callback, [int duration = 1000]) {
  return Timer(Duration(milliseconds: duration), callback);
}

void clearTimeout(Timer t) {
  t.cancel();
}

Future<String> request_box_description({
  String box_uuid,
}) async {
  print('request box description ($box_uuid) accessed');

  final http.Response response = await http.get(
    'http://webuser:webuser@10.100.8.35/api/v1/containermeta/$box_uuid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8; Accept-Language=ru-RU',
    },
  );

  print('response.body: ${response.body}');

  if (response.statusCode == 201 || response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('response status code is ${response.statusCode}');
  }
}

Future<String> request_box_intervals({
  String box_uuid,
}) async {
  print('request box intervals () accessed');

  final http.Response response = await http.get(
    'http://188.130.155.66/api/get_intervals_box/?uuid_box=$box_uuid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Content-Encoding': 'gzip',
    },
  );

  print('response.body: ${response.body}');

  // print('${utf8.decode(response.body[0]['name'])}'); // четотакое: отдельные поляя ютф декодить

  if (response.statusCode == 201 || response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('response status code is ${response.statusCode}');
  }
}
