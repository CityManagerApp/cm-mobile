import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15.2,
            letterSpacing: 1.0,
          ),
        ),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Theme.of(context).buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        textColor: Colors.white,
        onPressed: onClicked,
      );
}
