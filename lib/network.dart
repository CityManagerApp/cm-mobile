import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';

import 'main.dart';

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
    '${global["server_url"]}/api/v1/containermeta/$containerId',
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
    '${global["server_url"]}/api/v1/childrenitems/$containerId/MACROINFO',
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
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('yyyy.MM.dd hh:mm:ss');
  String formattedDate = formatter.format(now);
  print('formated date $formattedDate');
  final http.Response response = await http.post(
    '${global["server_url"]}/api/v1/postitem',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8; Accept-Language=ru-RU',
    },
    body: '{"parent_uuid":"$containerId",'
        '"name":"$formattedDate",'
        '"type":"IMAGE","meta":{"name":"$formattedDate",'
        '"leaf": true,'
        '"date_time": "$formattedDate", '
        '"description": "Без описания",'
        '"tree_visible": false,'
        ' "label_date_time": {"label":"Дата и время создания"},'
        ' "label_description": {"label":"Описание"}},'
        '"data":{"size": "0Mb", '
        '"base64": "$imageBase64", "original_file_name": "$formattedDate"}}',
  );
}

Future<String> uploadMacro({
  Map<String, String> macroInfo,
  String containerId,
}) async {
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('yyyy.MM.dd hh:mm:ss');
  String formattedDate = formatter.format(now);
  print('upload macro accessed ${macroInfo['interval']}, $containerId');
  String uploadMode = 'postitem';
  // если спуллено на ините то делаем только апдейт (уже создано)
  if (global.containsKey("pulled_intervals")) {
    if (global["pulled_intervals"].contains(macroInfo['interval'])) {
      uploadMode = 'updateitem';
    }
  }
  // сам запрос
  final http.Response response = await http.post(
    '${global["server_url"]}/api/v1/$uploadMode}',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8; Accept-Language=ru-RU',
    },
    body: '{"parent_uuid":"$containerId",'
        '"name":"${macroInfo['interval']}",'
        '"type":"MACROINFO",'
        '"meta":{"leaf":true,'
        '"date_time":"$formattedDate",'
        '"depth_end":${macroInfo['interval'].split('-')[1]},'
        '"depth_start":${macroInfo['interval'].split('-')[0]},'
        '"description":"${macroInfo['text_description']}",'
        '"tree_visible":false,'
        '"label_date_time":{"label":"Дата и время создания"},'
        '"label_depth_end":{"label":"Конец интервала"},'
        '"label_depth_start":{"label":"Начало интервала"},'
        '"label_description":{"label":"Описание"}},"data":{}}',
    encoding: Encoding.getByName("utf-8"),
  );
  // если отправили новый то в дальнейшем нужно будет апдейтать только
  if (uploadMode == 'postitem') {
    print('postitem response: ${response.body.length}');
    if (global.containsKey("pulled_intervals")) {
      global["pulled_intervals"].add(macroInfo['interval']);
    } else {
      global["pulled_intervals"] = [macroInfo['interval']];
    }
  }
}
