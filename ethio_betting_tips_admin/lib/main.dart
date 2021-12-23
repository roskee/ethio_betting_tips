import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethio_betting_tips_admin/firebase_options.dart';
import 'package:ethio_betting_tips_admin/match_screen.dart';
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
  late final API api;
  bool isReady = false, isLoggedIn = false;
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
    api = API(FirebaseFirestore.instance, FirebaseAuth.instance, reload);
    reload();
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
                children: [
                  SizedBox(
                      height: 200,
                      child: Center(
                          child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: 30),
                              child: SizedBox(
                                  height: 150,
                                  child: Image.asset(
                                    'ethio_betting_tips_admin2048.png',
                                    fit: BoxFit.fitHeight,
                                  ))),
                          const Text('Ethio Betting Tips (Admin)',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ))),
                  const ListTile(
                    leading: Icon(
                      Icons.admin_panel_settings,
                      color: Colors.grey,
                    ),
                    title: Text(
                      'Add new Admin - (coming soon)',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    // TODO: Find a stable way to implement this method
                    // onTap: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAdminPage(api: api,)));
                    // },
                  ),
                  // TODO: implement if possible
                  // ListTile(
                  //   title: Text('User Count(50)'),
                  // ),
                  ListTile(
                      leading: Icon(Icons.logout),
                      onTap: () {
                        api.logout();
                      },
                      title: const Text('Log Out'))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MatchScreen(
                              api: api,
                              match: MatchTip.defaultTip(),
                              isNew: true,
                            )));
              },
              child: const Icon(Icons.add),
            ),
            body: (isReady)
                ? RefreshIndicator(
                    child: ListView(
                        children: List.generate(
                            matches.length,
                            (index) =>
                                MatchCard(api: api, match: matches[index]))),
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
                      ])))
        : LogInPage(api: api);
  }
}
