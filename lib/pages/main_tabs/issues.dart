import 'package:cm/models/issue.dart';
import 'package:cm/services/api.dart';
import 'package:cm/widgets/button.dart';
import 'package:cm/widgets/issue_card.dart';
import 'package:flutter/material.dart';

class IssuesTab extends StatefulWidget {
  List<dynamic> _issues = [];

  @override
  _IssuesTabState createState() => _IssuesTabState();
}

class _IssuesTabState extends State<IssuesTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 62),
          Padding(
            padding: const EdgeInsets.only(left: 19.0),
            child: Text(
              "Мои заявки",
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
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 263,
                  child: FutureBuilder(
                    future: Api.getAllIssues(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print(snapshot.hasData);
                      if (snapshot.hasData) {
                        List<Issue> issues = snapshot.data;
                        return Container(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: issues.length,
                            itemBuilder: (context, index) {
                              return IssueCardWidget(
                                issue: issues[index],
                              );
                            },
                          ),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height - 160,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Загрузка...",
                                style: TextStyle(
                                  color: Color(0xff323232),
                                  fontSize: 24,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    text: 'Новая заявка +',
                    onTap: () {
                      Navigator.of(context).pushNamed('/new_issue');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
