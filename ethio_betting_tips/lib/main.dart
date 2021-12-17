import 'package:ethio_betting_tips/search.dart';
import 'package:flutter/material.dart';

import 'api.dart';
import 'components/icon_text.dart';
import 'components/titled_text.dart';
import 'match_card.dart';

void main() {
  runApp(const EthioBettingTips());
}

class EthioBettingTips extends StatelessWidget {
  const EthioBettingTips({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MatchTip> matches=[];
  API api=API();
  @override
  void initState(){
    super.initState();
    matches= api.getAllMatchs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ethio Betting Tips"),
          actions: [
            // search icon
            IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>const SearchPage()));
            }, icon: const Icon(Icons.search))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: const [
              SizedBox(
                  height: 200,
                  child: Center(child: Text('Ethio Betting Tips'))),
              ListTile(
                title: Text('Send Feedback'),
              ),
              ListTile(
                title: Text('Rate App'),
              ),
              ListTile(title: Text('About'))
            ],
          ),
        ),
        body: ListView(children: List.generate(matches.length, (index) => MatchCard(match: matches[index]))));
  }
}

