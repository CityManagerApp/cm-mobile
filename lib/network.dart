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
    'https://webuser:webuser@kernlab.devogip.ru/api/v1/containermeta/$box_uuid',
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
