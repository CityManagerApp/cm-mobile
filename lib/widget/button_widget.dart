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
            fontSize: 18,
            letterSpacing: 1.0,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        textColor: Colors.white,
        onPressed: onClicked,
      );
}
