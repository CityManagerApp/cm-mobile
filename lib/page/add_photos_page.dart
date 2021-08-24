import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

Image selectedFile;
bool selected = false;
const double MAX_PHOTO_WIDTH = 300;

class _AddPhotosPage extends State<AddPhotosPage> {
  getImage(ImageSource src) async {
    File img = await ImagePicker.pickImage(source: src);

    if (img != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: img.path,
        // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        // maxWidth: 300,
        // maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarTitle: "Выделите только необходимое",
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.white,
        ),
      );

      var croppedDecoded = await decodeImageFromList(cropped.readAsBytesSync());
      print(
          'decoded image dimensions: w${croppedDecoded.width}, h${croppedDecoded.height}');
      selected = true;
      selectedFile = Image.file(
        cropped,
        width: croppedDecoded.width > MAX_PHOTO_WIDTH
            ? MAX_PHOTO_WIDTH
            : croppedDecoded.width,
      );

      String t = selectedFile.image
          .toString()
          .substring(11, selectedFile.image.toString().length - 1 - 13);
      String croppedBase64 = base64Encode(File(t).readAsBytesSync());

      print('base64 $croppedBase64'); // 'log()' to see full

      uploadImage(
          imageBase64: croppedBase64,
          containerId: global["container_uuid"],
      );


      this.setState(() {
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
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              child: selected
                  ? selectedFile
                  : Icon(Icons.insert_photo,
                      size: 64, color: Colors.blueAccent.withOpacity(0.5)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    print('Сфоткать');
                    getImage(ImageSource.camera).then((completion) {
                      Fluttertoast.showToast(
                        msg: 'Фотка отправлена!',
                      );
                    });
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
