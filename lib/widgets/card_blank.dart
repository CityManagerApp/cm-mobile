import 'package:cm/models/issue.dart';
import 'package:flutter/material.dart';

class CardBlank extends StatefulWidget {
  final Widget child;

  const CardBlank({Key key, this.child}) : super(key: key);

  @override
  _CardBlankState createState() => _CardBlankState();
}

class _CardBlankState extends State<CardBlank> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: widget.child,
      ),
    );
  }
}
