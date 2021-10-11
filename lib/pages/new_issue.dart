import 'package:cm/pages/main_tabs/notifications.dart';
import 'package:cm/services/api.dart';
import 'package:cm/widgets/background.dart';
import 'package:cm/widgets/card_blank.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cm/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main_tabs/issues.dart';
import 'main_tabs/map.dart';
import 'main_tabs/settings.dart';

class NewIssuePage extends StatefulWidget {
  @override
  _NewIssuePageState createState() => _NewIssuePageState();
}

class _NewIssuePageState extends State<NewIssuePage> {
  final List<Tab> tabs = <Tab>[
    Tab(text: '🏠'),
    Tab(text: '🗺'),
    Tab(text: '🔔'),
    Tab(text: '⚙️'),
  ];

  var _formKey = GlobalKey<FormState>();
  var titleFieldController = TextEditingController();
  var contentFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            print('going back...');
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        body: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomStart,
          children: [
            BackgroundColorWidget(),
            BackgroundImageWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 95),
                  Padding(
                    padding: const EdgeInsets.only(left: 19.0),
                    child: Text(
                      "Новая заявка",
                      style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CardBlank(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Form(
                                key: _formKey,
                                onChanged: () {
                                  // print('changed input to form');
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: titleFieldController,
                                        textCapitalization: TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFFFFFFF),
                                            ),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          hintText: 'Например, Нет пешеходного перехода',
                                          labelText: 'Название',
                                        ),
                                        onSaved: (String value) {
                                          print('Title changed with $value');
                                        },
                                        validator: (String value) {
                                          return (value != null && value.contains('@'))
                                              ? 'Do not use the @ char.'
                                              : null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: contentFieldController,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 5,
                                        maxLines: 5,
                                        textCapitalization: TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFFFFFFF),
                                            ),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          hintText: 'Опишите проблему более подробно',
                                          labelText: 'Содержание проблемы',
                                        ),
                                        onSaved: (String value) {
                                          print('Title changed with $value');
                                        },
                                        validator: (String value) {
                                          return (value != null && value.contains('@'))
                                              ? 'Do not use the @ char.'
                                              : null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ButtonWidget(
                        text: 'Отправить',
                        onTap: () async {
                          var title = titleFieldController.text;
                          var content = contentFieldController.text;
                          print("sending $title -- $content");
                          informUser('Отправляем...', 500);
                          Api.createIssue(
                            title: title,
                            content: content,
                          ).then((_) => informUser('Отправлено!', 1500));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void informUser(String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration),
        padding: const EdgeInsets.all(8.0),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

}
