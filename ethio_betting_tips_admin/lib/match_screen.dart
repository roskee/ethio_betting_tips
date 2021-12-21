import 'package:ethio_betting_tips_admin/components/icon_text.dart';
import 'package:ethio_betting_tips_admin/components/titled_text.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen(
      {Key? key,
      required this.match})
      : super(key: key);
  final MatchTip match;

  Widget iconTextFor(int x) {
    switch (x) {
      case -1:
        return const IconText(text: 'L', backgroundColor: Colors.red);
      case 0:
        return const IconText(text: 'D', backgroundColor: Colors.yellow);
      case 1:
        return const IconText(text: 'W', backgroundColor: Colors.green);
      default:
        return const IconText(
          text: ' ',
          backgroundColor: Colors.grey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${match.home} VS ${match.away}')),
        body: ListView(children: [
          Card(
              elevation: 3,
              margin: const EdgeInsets.all(10),
              child: SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      Card(
                          elevation: 1,
                          child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TitledWidget(
                                      title: 'Home', content: Text(match.home)),
                                  const VerticalDivider(),
                                  const Text('VS'),
                                  const VerticalDivider(),
                                  TitledWidget(
                                      title: 'Away', content: Text(match.away))
                                ],
                              ))),
                      Card(
                          elevation: 1,
                          child: SizedBox(
                              height: 30,
                              width: Size.infinite.width,
                              child: Center(child: Text('Time: ${match.time.month}/${match.time.day} - ${match.time.hour}:${match.time.minute}')))),
                      Card(
                          elevation: 0,
                          child: SizedBox(
                              height: 80,
                              child: TitledWidget(
                                  title: 'Last 5 Matches',
                                  titleFontSize: 14,
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Wrap(
                                        children: [
                                          iconTextFor(match.homeRecord[0]),
                                          iconTextFor(match.homeRecord[1]),
                                          iconTextFor(match.homeRecord[2]),
                                          iconTextFor(match.homeRecord[3]),
                                          iconTextFor(match.homeRecord[4])
                                        ],
                                      ),
                                      const VerticalDivider(
                                        width: 25,
                                      ),
                                      Wrap(
                                        children: [
                                          iconTextFor(match.awayRecord[0]),
                                          iconTextFor(match.awayRecord[1]),
                                          iconTextFor(match.awayRecord[2]),
                                          iconTextFor(match.awayRecord[3]),
                                          iconTextFor(match.awayRecord[4]),
                                        ],
                                      ),
                                    ],
                                  ))))
                    ],
                  ))),
          Container(
              height: 300,
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(1, 1), blurRadius: 1)
              ]),
              child: TitledWidget(
                  title: 'Tips',
                  titleFontSize: 14,
                  content: ListView(children: [
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(10),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 70,
                          child: TitledWidget(
                            title: '1X2',
                            titleFontSize: 14,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: match.winTip == 1
                                                ? Colors.green
                                                : Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(child: Text('1')))),
                                const VerticalDivider(),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: match.winTip == 0
                                                ? Colors.green
                                                : Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(child: Text('X')))),
                                const VerticalDivider(),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: match.winTip == 2
                                                ? Colors.green
                                                : Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(child: Text('2'))))
                              ],
                            ),
                          )),
                    ),
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(10),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 70,
                          child: TitledWidget(
                            title: 'Over/Under',
                            titleFontSize: 14,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: match.overUnderTip>0?Colors.green: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                                'Over ${(match.overUnderTip.abs())}')))),
                                const VerticalDivider(),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: match.overUnderTip<0?Colors.green:Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        //color: Colors.green,
                                        child: Center(
                                            child: Text(
                                                'Under ${match.overUnderTip.abs()}')))),
                              ],
                            ),
                          )),
                    ),
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(10),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 70,
                          child: TitledWidget(
                            title: 'Both Teams to Score',
                            titleFontSize: 14,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: match.gGTip
                                                ? Colors.white
                                                : Colors.green,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        //color: Colors.green,
                                        child:
                                            const Center(child: Text('No')))),
                                const VerticalDivider(),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: match.gGTip
                                                ? Colors.green
                                                : Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        //color: Colors.green,
                                        child:
                                            const Center(child: Text('Yes')))),
                              ],
                            ),
                          )),
                    ),
                  ])))
        ]));
  }
}
