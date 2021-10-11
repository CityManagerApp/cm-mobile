import 'package:cm/models/issue.dart';
import 'package:flutter/material.dart';

class IssueCardWidget extends StatefulWidget {
  final Issue issue;

  const IssueCardWidget({
    this.issue,
  });

  @override
  _IssueCardWidgetState createState() => _IssueCardWidgetState();
}

class _IssueCardWidgetState extends State<IssueCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.5, vertical: 14.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.issue.status == "в обработке" ? const Color(0xffffb800) : const Color(0xff24ff00),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.issue.title,
                  style: TextStyle(
                    color: Color(0xff030202),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.issue.content,
              style: TextStyle(
                color: Color(0xff000000).withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 13,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 11.5),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Color(0xff000000),
                ),
                children: [
                  TextSpan(
                    text: 'Статус: ',
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  TextSpan(
                    text: widget.issue.status,
                    style: TextStyle(
                      color: Color(0xff000000).withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
