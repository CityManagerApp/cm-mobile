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
  print('request_well_description accessed');

  final http.Response response = await http.get(
    'http://188.130.155.66/api/get_box/?uuid_box=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  print('repsonse.body: ${response.body}');

  if (response.statusCode == 201 || response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('response status code is ${response.statusCode}');
  }
}
