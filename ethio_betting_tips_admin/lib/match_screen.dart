import 'package:ethio_betting_tips_admin/components/freezable.dart';
import 'package:ethio_betting_tips_admin/components/icon_text.dart';
import 'package:ethio_betting_tips_admin/components/titled_text.dart';
import 'package:ethio_betting_tips_admin/components/toggle_widget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

import 'api.dart';

// TODO: flutter_datetime_picker warning !!!
class MatchScreen extends StatefulWidget {
  const MatchScreen(
      {Key? key, required this.api, required this.match, this.isNew = false})
      : super(key: key);
  final MatchTip match;
  final API api;
  final bool isNew;
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool isEditing = false;
  bool isFrozen = false;
  late MatchTip editableTip;
  TextEditingController? homeController, awayController;
  @override
  void initState() {
    super.initState();
    editableTip = widget.match;
    if (widget.isNew) isEditing = true;
    homeController = TextEditingController(text: editableTip.home);
    awayController = TextEditingController(text: editableTip.away);
  }

  String getDateTimeFormat(DateTime dateTime) {
    String date = '';
    date += dateTime.month < 10 ? '0${dateTime.month}' : '${dateTime.month}';
    date += '/';
    date += dateTime.day < 10 ? '0${dateTime.day}' : '${dateTime.day}';
    date += ' - ';
    date += dateTime.hour < 10 ? '0${dateTime.hour}' : '${dateTime.hour}';
    date += ':';
    date += dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
    return date;
  }

  Widget iconTextFor(int x) {
    switch (x) {
      case -1:
        return const IconText(text: 'L', backgroundColor: Colors.red);
      case 0:
        return const IconText(text: 'D', backgroundColor: Colors.yellow);
      case 1:
        return IconText(
            text: 'W',
            backgroundColor: isEditing ? Colors.lightGreen : Colors.green);
      default:
        return const IconText(
          text: ' ',
          backgroundColor: Colors.grey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Freezable(
      isFrozen: isFrozen,
      child: Scaffold(
          floatingActionButton: isEditing
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                    if (widget.isNew) {
                      setState(() {
                        isFrozen = true;
                      });
                      widget.api.addTip(editableTip).then((id) {
                        setState(() {
                          editableTip = editableTip.editTip(id: id);
                          isFrozen = false;
                        });
                      });
                    } else {
                      widget.api.updateTip(editableTip);
                    }
                  },
                  elevation: 10,
                  isExtended: true,
                  backgroundColor: Colors.lightGreen,
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  child: const Icon(Icons.edit),
                ),
          appBar: isEditing
              ? AppBar(
                  title: const Text('Editing Match...'),
                  backgroundColor: Colors.lightGreen,
                )
              : AppBar(
                  title: Text(
                    '${editableTip.home} - ${editableTip.away}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Warning'),
                                    content: const Text(
                                        'Are you sure to delete this tip?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text('OK'))
                                    ],
                                  )).then((value) {
                            if (value == true) {
                              setState(() {
                                isFrozen = true;
                              });
                              widget.api.deleteTip(editableTip).then((_) {
                                setState(() {
                                  isFrozen = false;
                                });
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
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
                                            content: SizedBox(
                                              width: 140,
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    editableTip =
                                                        editableTip.editTip(
                                                            home:
                                                                homeController!
                                                                    .value
                                                                    .text);
                                                  });
                                                },
                                                textAlign: TextAlign.center,
                                                controller: homeController,
                                                readOnly: !isEditing,
                                              ),
                                            )),
                                        Visibility(
                                            visible: isEditing,
                                            child: const Padding(
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    Icon(Icons.edit, size: 16)))
                                      ],
                                    ),
                                    const VerticalDivider(),
                                    const Text('VS'),
                                    const VerticalDivider(),
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        TitledWidget(
                                            title: 'Away',
                                            content: SizedBox(
                                                width: 140,
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      editableTip =
                                                          editableTip.editTip(
                                                              away:
                                                                  awayController!
                                                                      .value
                                                                      .text);
                                                    });
                                                  },
                                                  textAlign: TextAlign.center,
                                                  controller: awayController,
                                                  readOnly: !isEditing,
                                                ))),
                                        Visibility(
                                            visible: isEditing,
                                            child: const Padding(
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    Icon(Icons.edit, size: 16)))
                                      ],
                                    )
                                  ],
                                ))),
                        InkWell(
                            onTap: isEditing
                                ? () {
                                    DatePicker.showDateTimePicker(
                                      context,
                                      minTime: DateTime.now(),
                                      currentTime: editableTip.time,
                                      maxTime:
                                          DateTime(DateTime.now().year + 1, 6),
                                      onConfirm: (date) {
                                        setState(() {
                                          editableTip =
                                              editableTip.editTip(time: date);
                                        });
                                      },
                                    );
                                  }
                                : null,
                            child:
                                Stack(alignment: Alignment.topRight, children: [
                              Card(
                                  elevation: 1,
                                  child: SizedBox(
                                      height: 30,
                                      width: Size.infinite.width,
                                      child: Center(
                                          child: Text(getDateTimeFormat(
                                              editableTip.time))))),
                              Visibility(
                                  visible: isEditing,
                                  child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.edit, size: 16)))
                            ])),
                        InkWell(
                            onTap: isEditing
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: Card(
                                                  child: SizedBox(
                                                      height: 300,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  TitledWidget(
                                                                title:
                                                                    'Tap to Change',
                                                                dividerWidth: 1,
                                                                titleFontSize:
                                                                    18,
                                                                content: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              TitledWidget(
                                                                            title:
                                                                                editableTip.home,
                                                                            titleFontSize:
                                                                                16,
                                                                            dividerWidth:
                                                                                1,
                                                                            content:
                                                                                Column(
                                                                              children: [
                                                                                ToggleWidget(
                                                                                  toggleWidgetList: [
                                                                                    iconTextFor(-1),
                                                                                    iconTextFor(0),
                                                                                    iconTextFor(1)
                                                                                  ],
                                                                                  onToggleChange: (index) {
                                                                                    List<int> temp = List.from(editableTip.homeRecord);
                                                                                    temp.replaceRange(0, 1, [
                                                                                      index - 1
                                                                                    ]);
                                                                                    setState(() {
                                                                                      editableTip = editableTip.editTip(homeRecord: temp);
                                                                                    });
                                                                                  },
                                                                                  valueIndex: editableTip.homeRecord[0] + 1,
                                                                                ),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.homeRecord);
                                                                                      temp.replaceRange(1, 2, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(homeRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.homeRecord[1] + 1),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.homeRecord);
                                                                                      temp.replaceRange(2, 3, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(homeRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.homeRecord[2] + 1),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.homeRecord);
                                                                                      temp.replaceRange(3, 4, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(homeRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.homeRecord[3] + 1),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.homeRecord);
                                                                                      temp.replaceRange(4, 5, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(homeRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.homeRecord[4] + 1)
                                                                              ],
                                                                            ),
                                                                          )),
                                                                      const VerticalDivider(),
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child: TitledWidget(
                                                                              title: editableTip.away,
                                                                              titleFontSize: 16,
                                                                              dividerWidth: 1,
                                                                              content: Column(children: [
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.awayRecord);
                                                                                      temp.replaceRange(0, 1, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(awayRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.awayRecord[0] + 1),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.awayRecord);
                                                                                      temp.replaceRange(1, 2, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(awayRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.awayRecord[1] + 1),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.awayRecord);
                                                                                      temp.replaceRange(2, 3, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(awayRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.awayRecord[2] + 1),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.awayRecord);
                                                                                      temp.replaceRange(3, 4, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(awayRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.awayRecord[3] + 1),
                                                                                ToggleWidget(
                                                                                    toggleWidgetList: [
                                                                                      iconTextFor(-1),
                                                                                      iconTextFor(0),
                                                                                      iconTextFor(1)
                                                                                    ],
                                                                                    onToggleChange: (index) {
                                                                                      List<int> temp = List.from(editableTip.awayRecord);
                                                                                      temp.replaceRange(4, 5, [
                                                                                        index - 1
                                                                                      ]);
                                                                                      setState(() {
                                                                                        editableTip = editableTip.editTip(awayRecord: temp);
                                                                                      });
                                                                                    },
                                                                                    valueIndex: editableTip.awayRecord[4] + 1)
                                                                              ])))
                                                                    ]),
                                                              ),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'))
                                                          ]))),
                                            ));
                                  }
                                : null,
                            child: Stack(
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Wrap(
                                                  children: [
                                                    iconTextFor(editableTip
                                                        .homeRecord[0]),
                                                    iconTextFor(editableTip
                                                        .homeRecord[1]),
                                                    iconTextFor(editableTip
                                                        .homeRecord[2]),
                                                    iconTextFor(editableTip
                                                        .homeRecord[3]),
                                                    iconTextFor(editableTip
                                                        .homeRecord[4])
                                                  ],
                                                ),
                                                const VerticalDivider(
                                                  width: 25,
                                                ),
                                                Wrap(
                                                  children: [
                                                    iconTextFor(editableTip
                                                        .awayRecord[0]),
                                                    iconTextFor(editableTip
                                                        .awayRecord[1]),
                                                    iconTextFor(editableTip
                                                        .awayRecord[2]),
                                                    iconTextFor(editableTip
                                                        .awayRecord[3]),
                                                    iconTextFor(editableTip
                                                        .awayRecord[4]),
                                                  ],
                                                ),
                                              ],
                                            )))),
                                Visibility(
                                    visible: isEditing,
                                    child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.edit, size: 16)))
                              ],
                            )),
                      ],
                    ))),
            Container(
                height: 500,
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 1)
                    ]),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    TitledWidget(
                        title: 'Tips',
                        titleFontSize: 14,
                        content: Column(children: [
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: InkResponse(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: isEditing
                                                ? () {
                                                    setState(() {
                                                      editableTip = editableTip
                                                          .editTip(winTip: 1);
                                                    });
                                                  }
                                                : null,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: editableTip.winTip ==
                                                            1
                                                        ? isEditing
                                                            ? Colors.lightGreen
                                                            : Colors.green
                                                        : Colors.white,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 1)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                    child: Text('1'))),
                                          )),
                                      const VerticalDivider(),
                                      Expanded(
                                          flex: 1,
                                          child: InkResponse(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: isEditing
                                                ? () {
                                                    setState(() {
                                                      editableTip = editableTip
                                                          .editTip(winTip: 0);
                                                    });
                                                  }
                                                : null,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: editableTip.winTip ==
                                                            0
                                                        ? isEditing
                                                            ? Colors.lightGreen
                                                            : Colors.green
                                                        : Colors.white,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 1)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                    child: Text('X'))),
                                          )),
                                      const VerticalDivider(),
                                      Expanded(
                                          flex: 1,
                                          child: InkResponse(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: isEditing
                                                ? () {
                                                    setState(() {
                                                      editableTip = editableTip
                                                          .editTip(winTip: 2);
                                                    });
                                                  }
                                                : null,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: editableTip.winTip ==
                                                            2
                                                        ? isEditing
                                                            ? Colors.lightGreen
                                                            : Colors.green
                                                        : Colors.white,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 1)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                    child: Text('2'))),
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
                                height: 270,
                                child: TitledWidget(
                                  title: 'Over/Under',
                                  titleFontSize: 14,
                                  content: Column(
                                    children: [
                                      for (double i = 0.5; i < 5.5; i++)
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: SizedBox(
                                            height: 35,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: InkResponse(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: isEditing
                                                          ? () {
                                                              setState(() {
                                                                editableTip =
                                                                    editableTip
                                                                        .editTip(
                                                                  overUnderTip:
                                                                      i,
                                                                );
                                                              });
                                                            }
                                                          : null,
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: editableTip
                                                                              .overUnderTip ==
                                                                          i
                                                                      ? isEditing
                                                                          ? Colors
                                                                              .lightGreen
                                                                          : Colors
                                                                              .green
                                                                      : Colors
                                                                          .white,
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        offset: Offset(
                                                                            1,
                                                                            1),
                                                                        blurRadius:
                                                                            1)
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                          child: Center(
                                                              child: Text(
                                                                  'Over $i'))),
                                                    )),
                                                const VerticalDivider(),
                                                Expanded(
                                                    flex: 1,
                                                    child: InkResponse(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: isEditing
                                                          ? () {
                                                              setState(() {
                                                                editableTip =
                                                                    editableTip
                                                                        .editTip(
                                                                  overUnderTip:
                                                                      i * -1,
                                                                );
                                                              });
                                                            }
                                                          : null,
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: editableTip
                                                                              .overUnderTip ==
                                                                          i * -1
                                                                      ? isEditing
                                                                          ? Colors
                                                                              .lightGreen
                                                                          : Colors
                                                                              .green
                                                                      : Colors
                                                                          .white,
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        offset: Offset(
                                                                            1,
                                                                            1),
                                                                        blurRadius:
                                                                            1)
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                          //color: Colors.green,
                                                          child: Center(
                                                              child: Text(
                                                                  'Under $i'))),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: InkResponse(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: isEditing
                                                ? () {
                                                    setState(() {
                                                      editableTip =
                                                          editableTip.editTip(
                                                              gGTip: false);
                                                    });
                                                  }
                                                : null,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: editableTip.gGTip
                                                        ? Colors.white
                                                        : isEditing
                                                            ? Colors.lightGreen
                                                            : Colors.green,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 1)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                //color: Colors.green,
                                                child: const Center(
                                                    child: Text('No'))),
                                          )),
                                      const VerticalDivider(),
                                      Expanded(
                                          flex: 1,
                                          child: InkResponse(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: isEditing
                                                ? () {
                                                    setState(() {
                                                      editableTip = editableTip
                                                          .editTip(gGTip: true);
                                                    });
                                                  }
                                                : null,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: editableTip.gGTip
                                                        ? isEditing
                                                            ? Colors.lightGreen
                                                            : Colors.green
                                                        : Colors.white,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 1)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                //color: Colors.green,
                                                child: const Center(
                                                    child: Text('Yes'))),
                                          )),
                                    ],
                                  ),
                                )),
                          ),
                        ])),
                    Visibility(
                        visible: isEditing,
                        child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.edit, size: 16)))
                  ],
                ))
          ])),
    );
  }
}
