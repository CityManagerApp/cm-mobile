import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

Timer setTimeout(callback, [int duration = 1000]) {
  return Timer(Duration(milliseconds: duration), callback);
}

void clearTimeout(Timer t) {
  t.cancel();
}

Future<String> getContainerDescription({
  String containerId,
}) async {
  print('request box description ($containerId) accessed');

  final http.Response response = await http.get(
    'https://webuser:webuser@kernlab.devogip.ru/api/v1/containermeta/$containerId',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8; Accept-Language=ru-RU',
    },
  );

  print('getContainerDescription response.body: ${response.body}');

  if (response.statusCode == 201 || response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('response status code is ${response.statusCode}');
  }
}

Future<String> getContainerMacros({
  String containerId,
}) async {
  print('request macros ($containerId) accessed');

  final http.Response response = await http.get(
    'https://webuser:webuser@kernlab.devogip.ru/api/v1/childrenitems/$containerId/MACROINFO',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8; Accept-Language=ru-RU',
    },
  );

  print('getContainerMacros response.body');

  if (response.statusCode == 201 || response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('response status code is ${response.statusCode}');
  }
}

Future<String> uploadImage({
  String imageBase64,
  String containerId,
}) async {
  // DateTime now = new DateTime.now();
  // var formatter = new DateFormat('yyyy-MM-dd');
  // String formattedDate = formatter.format(now);
  // print(formattedDate); // 2016-01-25
  final http.Response response = await http.post(
    'https://webuser:webuser@kernlab.devogip.ru/api/v1/postitem',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8; Accept-Language=ru-RU',
    },
    body: '{"parent_uuid":"00000001-0001-0001-0001-000000000000",'
        '"name":"superImage",'
        '"type":"IMAGE",'
        '"meta":{"leaf": true,"date_time": "2021.01.01 11:11:11", "description": "Без описания8080","tree_visible": false, "label_date_time": "Дата и время создания", "label_description": "Описание"},'
        '"data":{"size": "0Mb", "base64": "$imageBase64", "original_file_name": "test.jpg"}}',
  );
}

Future<String> uploadMacro({
  Map<String, String> macroInfo,
  String containerId,
}) async {
  final http.Response response = await http.post(
    'https://webuser:webuser@kernlab.devogip.ru/api/v1/postitem',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8; Accept-Language=ru-RU',
    },
    body: '{"parent_uuid":"00000001-0001-0001-0001-000000000000",'
        '"name":"super",'
        '"type":"MACROINFO",'
        '"meta":{"leaf":true,'
        '"date_time":"2021.01.01 11:11:11",'
        '"depth_end":1001.5,'
        '"depth_start":1000,'
        '"description":"Переход в нефтенасыщеный пласт",'
        '"tree_visible":false,'
        '"label_date_time":"Дата и время создания",'
        '"label_depth_end":"Конец интервала",'
        '"label_depth_start":"Начало интервала",'
        '"label_description":"Описание"},"data":{}}',
  );
}
