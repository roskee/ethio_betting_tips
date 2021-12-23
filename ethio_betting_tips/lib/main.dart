import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethio_betting_tips/firebase_options.dart';
import 'package:ethio_betting_tips/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'api.dart';
import 'match_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  List<MatchTip> matches = [];
  API api = API(FirebaseFirestore.instance);
  bool isReady = false;
  Future<void> reload() async {
    List<MatchTip> temp = await api.getAllMatchs();
    setState(() {
      isReady = true;
      matches = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ethio Betting Tips"),
          actions: [
            // search icon
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                                api: api,
                              )));
                },
                icon: const Icon(Icons.search))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                  height: 200,
                  child: Center(
                      child:
                          Stack(alignment: Alignment.bottomCenter, children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: SizedBox(
                            height: 150,
                            child: Image.asset(
                              'ethio_betting_tips2048.png',
                              fit: BoxFit.fitHeight,
                            ))),
                    Text('Ethio Betting Tips', style: TextStyle(fontSize: 16))
                  ]))),
              //TODO: should be done upon release
              // ListTile(
              //   title: Text('Send Feedback'),
              // ),
              // ListTile(
              //   title: Text('Rate App'),
              // ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('About'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: Text('About Developer'),
                              content: SelectableText(
                                'Hi, I am Kirubel Adamu. I developed this simple application for you football fans out there who want to get daily tips for reference.\n\nEmail:kirubeladamu@gmail.com',
                                textAlign: TextAlign.justify,
                              ),
                              actions: [
                                TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ]));
                },
              )
            ],
          ),
        ),
        body: (isReady)
            ? RefreshIndicator(
                child: ListView(
                    children: List.generate(matches.length,
                        (index) => MatchCard(match: matches[index]))),
                onRefresh: () async {
                  await reload();
                },
              )
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                    CircularProgressIndicator(),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text('Loading Tips')
                  ])));
  }
}
