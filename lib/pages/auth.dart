import 'package:cm/services/api.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cm/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String initialCountry = 'RU';

  PhoneNumber number = PhoneNumber(isoCode: 'RU');

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            // image: DecorationImage(
            //   image: AssetImage(
            //     "assets/icons/background-tree.png",
            //   ),
            //   fit: BoxFit.cover,
            //   alignment: Alignment.bottomLeft,
            // ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Здравствуйте!",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Давайте познакомимся",
                  style: TextStyle(
                    color: Color(0xff323232),
                    fontSize: 24,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x22000000),
                        spreadRadius: 0,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Container(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                              child: InternationalPhoneNumberInput(
                                inputDecoration: InputDecoration(
                                  labelText: 'Ваш номер телефона',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFFFFF),
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: true,
                                autoValidateMode: AutovalidateMode.always,
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                                selectorTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                                initialValue: number,
                                textFieldController: controller,
                                formatInput: true,
                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                inputBorder: OutlineInputBorder(),
                                onSaved: (PhoneNumber number) {},
                                onInputChanged: (PhoneNumber value) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          text: "Войти",
                          onTap: onLoginTap,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "или",
                            style: TextStyle(
                              color: const Color(0xFF888888),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ButtonWidget(
                          text: "Регистрация",
                          onTap: onSignUpTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void onLoginTap() async {
    formKey.currentState.save();
    if (formKey.currentState.validate()) {
      print('phone number valid');
      informUser('Номер телефона принят');
      var phone = "+79518977157";
      var password = "helloworld49";
      var response = await Api.login(
        phone: phone,
        password: password,
      );
      if (Api.noErrors(response)) {
        Navigator.pushNamed(context, '/main');
      } else {
        informUser('Что-то пошло не так :/');
      }
    }
  }

  void onSignUpTap() async {
    var phone = "+79518997127";
    var password = "helloworld49";
    var response = await Api.signUp(
      phone: phone,
      password: password,
    );
    if (Api.noErrors(response)) {
      informUser('Вы успешно зарегистрированы! Входим в систему...');
      print("no errors found, automatically logging in...");
      response = await Api.login(
        phone: phone,
        password: password,
      );
    }
  }

  void updatePhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'RU');

    print('$number updated');

    setState(() {
      this.number = number;
    });
  }

  void informUser(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}