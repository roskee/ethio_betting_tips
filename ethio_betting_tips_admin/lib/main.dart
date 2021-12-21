import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethio_betting_tips_admin/firebase_options.dart';
import 'package:ethio_betting_tips_admin/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api.dart';
import 'login.dart';
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
      title: 'Ethio Betting Tips (Admin)',
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
  API api = API(FirebaseFirestore.instance, FirebaseAuth.instance);
  bool isReady = false, isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    api.getAllMatchs().then((value) {
      setState(() {
        isReady = true;
        matches = value;
      });
    });
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        setState(() {
          isLoggedIn = false;
        });
      } else {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Ethio Betting Tips (Admin)"),
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
                children: const [
                  SizedBox(
                      height: 200,
                      child: Center(child: Text('Ethio Betting Tips (Admin)'))),
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
            body: (isReady)
                ? ListView(
                    children: List.generate(matches.length,
                        (index) => MatchCard(match: matches[index])))
                : Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                        CircularProgressIndicator(),
                        Divider(
                          color: Colors.transparent,
                        ),
                        Text('Loading Tips')
                      ])))
        : LogInPage(api: api);
  }
}
