import 'package:flutter/material.dart';

import 'api.dart';
import 'match_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.api}) : super(key: key);
  final API api;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Widget> result = [];
  TextEditingController termController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Card(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                Expanded(
                    child: TextField(
                  cursorColor: Colors.white,
                  controller: termController,
                  onChanged: (value) {
                    // initiate search here

                    if (value.isNotEmpty) {
                      List<MatchCard> temp = [];
                      widget.api.getMatchsForResult(value).then((value) {
                        for (MatchTip matchTip in value) {
                          temp.add(MatchCard(match: matchTip));
                        }
                        setState(() {
                          result = temp;
                        });
                      });
                    } else {
                      setState(() {
                        result = [];
                      });
                    }
                  },
                )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        result = [
                          const Center(
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator()))
                        ];
                      });
                      List<MatchCard> temp = [];
                      widget.api
                          .getMatchsForResult(termController.value.text)
                          .then((value) {
                        for (MatchTip matchTip in value) {
                          temp.add(MatchCard(match: matchTip));
                        }
                        setState(() {
                          if (temp.isEmpty) {
                            result = [
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text('No Matches Found!'),
                              ))
                            ];
                          } else {
                            result = temp;
                          }
                        });
                      });
                    },
                    icon: const Icon(Icons.search))
              ],
            )),
      ),
      body: ListView(children: result),
    );
  }
}
