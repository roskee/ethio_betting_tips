import 'package:ethio_betting_tips_admin/components/icon_text.dart';
import 'package:ethio_betting_tips_admin/components/titled_text.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key, required this.api, required this.match})
      : super(key: key);
  final MatchTip match;
  final API api;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool isEditing = false;
  MatchTip? editableTip;
  TextEditingController? homeController, awayController;
  @override
  void initState() {
    super.initState();
    editableTip = widget.match;
    homeController = TextEditingController(text: editableTip!.home);
    awayController = TextEditingController(text: editableTip!.away);
  }

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
        floatingActionButton: isEditing
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
                elevation: 10,
                isExtended: true,
                backgroundColor: Colors.lightGreen,
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            : FloatingActionButton(
                onPressed: () {
                  // TODO: make the page editable
                  setState(() {
                    isEditing = true;
                  });
                },
                child: const Icon(Icons.edit),
              ),
        appBar: isEditing
            ? AppBar(
                title: Text('Editing Match...'),
                backgroundColor: Colors.lightGreen,
              )
            : AppBar(
                title: Text('${editableTip!.home} VS ${editableTip!.away}')),
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
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 Stack(
                                   alignment: Alignment.topRight,
                                    children: [
                                      TitledWidget(
                                          title: 'Home',
                                          content: SizedBox( //TODO: try more realistic solution
                                            width: 140,
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: homeController,
                                              readOnly: !isEditing,
                                            ),
                                          )),
                                          Visibility(
                            visible: isEditing,
                            child:const Padding(padding:EdgeInsets.all(10),child:Icon(Icons.edit,size:16)))
                                    ],
                                  ),
                                  const VerticalDivider(),
                                  const Text('VS'),
                                  const VerticalDivider(),
                                  Stack(
                                    alignment:Alignment.topRight,
                                    children: [
                                      TitledWidget(
                                          title: 'Away',
                                          content: SizedBox(
                                              width: 140,
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                controller: awayController,
                                                readOnly: !isEditing,
                                              ))),
                                              Visibility(
                            visible: isEditing,
                            child:const Padding(padding:EdgeInsets.all(10),child:Icon(Icons.edit,size:16)))
                                    ],
                                  )
                                ],
                              ))),
                      InkWell(
                        onTap: isEditing?() {}:null,
                        child: Stack(
                          
                          alignment: Alignment.topRight,
                          children:[Card(
                            elevation: 1,
                            child: SizedBox(
                                height: 30,
                                width: Size.infinite.width,
                                child: Center(
                                    child: Text(
                                        'Time: ${editableTip!.time.month}/${editableTip!.time.day} - ${editableTip!.time.hour}:${editableTip!.time.minute}')))),
                          Visibility(
                            visible: isEditing,
                            child:const Padding(padding:EdgeInsets.all(10),child:Icon(Icons.edit,size:16)))
                          ])
                      ),
        
                     
                      InkWell(
                        onTap: isEditing?(){}:null,
                        child:Stack(
                          alignment: Alignment.topRight,
                          children: [
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
                                                    iconTextFor(
                                                        editableTip!.homeRecord[0]),
                                                    iconTextFor(
                                                        editableTip!.homeRecord[1]),
                                                    iconTextFor(
                                                        editableTip!.homeRecord[2]),
                                                    iconTextFor(
                                                        editableTip!.homeRecord[3]),
                                                    iconTextFor(
                                                        editableTip!.homeRecord[4])
                                                  ],
                                                ),
                                          const VerticalDivider(
                                            width: 25,
                                          ),
                                          Wrap(
                                              children: [
                                                iconTextFor(
                                                    editableTip!.awayRecord[0]),
                                                iconTextFor(
                                                    editableTip!.awayRecord[1]),
                                                iconTextFor(
                                                    editableTip!.awayRecord[2]),
                                                iconTextFor(
                                                    editableTip!.awayRecord[3]),
                                                iconTextFor(
                                                    editableTip!.awayRecord[4]),
                                              ],
                                            ),
                                          
                                        ],
                                      )))),
                                      Visibility(
                            visible: isEditing,
                            child:const Padding(padding:EdgeInsets.all(10),child:Icon(Icons.edit,size:16)))
                          ],
                        )),
                    ],
                  ))),
          Container(
              height: 300,
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(1, 1), blurRadius: 1)
              ]),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TitledWidget(
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
                                        child: InkResponse(
                                           splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: isEditing?(){
                                            setState(() {
                                              editableTip=MatchTip(editableTip!.home, editableTip!.away, editableTip!.time, 1, editableTip!.overUnderTip, editableTip!.gGTip,homeRecord: editableTip!.homeRecord,awayRecord: editableTip!.awayRecord);
                                            });
                                          }:null,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: editableTip!.winTip == 1
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
                                              child: const Center(child: Text('1'))),
                                        )),
                                    const VerticalDivider(),
                                    Expanded(
                                        flex: 1,
                                        child: InkResponse(
                                           splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: isEditing?(){
                                            setState(() {
                                              editableTip=MatchTip(editableTip!.home, editableTip!.away, editableTip!.time, 0, editableTip!.overUnderTip, editableTip!.gGTip,homeRecord: editableTip!.homeRecord,awayRecord: editableTip!.awayRecord);
                                            });
                                          }:null,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: editableTip!.winTip == 0
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
                                              child: const Center(child: Text('X'))),
                                        )),
                                    const VerticalDivider(),
                                    Expanded(
                                        flex: 1,
                                        child: InkResponse(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: isEditing ? (){
                                            setState(() {
                                              editableTip=MatchTip(editableTip!.home, editableTip!.away, editableTip!.time, 2, editableTip!.overUnderTip, editableTip!.gGTip,homeRecord: editableTip!.homeRecord,awayRecord: editableTip!.awayRecord);
                                            });
                                          }:null,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: editableTip!.winTip == 2
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
                                              child: const Center(child: Text('2'))),
                                        ))
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
                                        child: InkResponse(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: isEditing?(){
                                              setState(() {
                                              editableTip=MatchTip(editableTip!.home, editableTip!.away, editableTip!.time, editableTip!.winTip, editableTip!.overUnderTip.abs(), editableTip!.gGTip,homeRecord: editableTip!.homeRecord,awayRecord: editableTip!.awayRecord);
                                            });
                                          }:null,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: editableTip!.overUnderTip > 0
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
                                              child: Center(
                                                  child: Text(
                                                      'Over ${(editableTip!.overUnderTip.abs())}'))),
                                        )),
                                    const VerticalDivider(),
                                    Expanded(
                                        flex: 1,
                                        child: InkResponse(
                                           splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: isEditing?(){
                                            setState(() {
                                              editableTip=MatchTip(editableTip!.home, editableTip!.away, editableTip!.time, editableTip!.winTip, editableTip!.overUnderTip.abs()*-1, editableTip!.gGTip,homeRecord: editableTip!.homeRecord,awayRecord: editableTip!.awayRecord);
                                            });
                                          }:null,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: editableTip!.overUnderTip < 0
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
                                              child: Center(
                                                  child: Text(
                                                      'Under ${editableTip!.overUnderTip.abs()}'))),
                                        )),
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
                                        child: InkResponse(
                                           splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: isEditing?(){
                                            setState(() {
                                              editableTip=MatchTip(editableTip!.home, editableTip!.away, editableTip!.time, editableTip!.winTip, editableTip!.overUnderTip,false,homeRecord: editableTip!.homeRecord,awayRecord: editableTip!.awayRecord);
                                            });
                                          }:null,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: editableTip!.gGTip
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
                                                  const Center(child: Text('No'))),
                                        )),
                                    const VerticalDivider(),
                                    Expanded(
                                        flex: 1,
                                        child: InkResponse(
                                           splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: isEditing?(){
                                            setState(() {
                                              editableTip=MatchTip(editableTip!.home, editableTip!.away, editableTip!.time, editableTip!.winTip, editableTip!.overUnderTip,true,homeRecord: editableTip!.homeRecord,awayRecord: editableTip!.awayRecord);
                                            });
                                          }:null,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: editableTip!.gGTip
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
                                                  const Center(child: Text('Yes'))),
                                        )),
                                  ],
                                ),
                              )),
                        ),
                      ])),
                      Visibility(
                            visible: isEditing,
                            child:const Padding(padding:EdgeInsets.all(10),child:Icon(Icons.edit,size:16)))
                ],
              ))
        ]));
  }
}
