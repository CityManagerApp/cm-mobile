import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';
import 'package:image_cropper/image_cropper.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:clik/network.dart';

import 'package:image_picker/image_picker.dart';

class AddPhotosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPhotosPage();
}

class _AddPhotosPage extends State<AddPhotosPage> {
  File _selectedFile;

  getImage(ImageSource src) async {
    File img = await ImagePicker.pickImage(source: src);

    if (img != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: img.path,
        // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        // maxWidth: 700,
        // maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarTitle: "Выделите только необходимое",
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.white,
        ),
      );

      this.setState(() {
        _selectedFile = cropped;
        if (global.keys.contains('kern_photos')) {
          global['kern_photos'].add(cropped);
        } else {
          global['kern_photos'] = [cropped];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Добавляем фотографии',
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    print('Сфоткать');
                    getImage(ImageSource.camera);
                  },
                  padding: EdgeInsets.all(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(Icons.photo_camera_outlined, color: Colors.blue),
                      SizedBox(height: 4),
                      Text("Сфоткать",
                          style: TextStyle(
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ),
                SizedBox(width: 32),
                OutlineButton(
                  onPressed: () {
                    print('С галереи');
                    getImage(ImageSource.gallery);
                  },
                  padding: EdgeInsets.all(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(Icons.photo_album_outlined, color: Colors.blue),
                      SizedBox(height: 4),
                      Text("С галереи",
                          style: TextStyle(
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
