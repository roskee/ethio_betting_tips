import 'package:ethio_betting_tips_admin/match_screen.dart';
import 'package:flutter/material.dart';

import 'api.dart';
import 'components/titled_text.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    Key? key,
    required this.match
  }) : super(key: key);
  final MatchTip match;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MatchScreen(
                        match: match,
                        )));
        },
        child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(5),
            child: SizedBox(
                height: 50,
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, // dec 12 -17:30
                      children: [
                        TitledWidget(title: 'time', content: Text("${match.time.month}/${match.time.day} - ${match.time.hour}:${match.time.minute}")),
                        const VerticalDivider(),
                        Expanded(
                            child: Center(
                                child: TitledWidget(
                                    title: 'match',
                                    content: Text('${match.home} VS ${match.away}')))),
                        const VerticalDivider(),
                        TitledWidget(title: 'win', content: Text('${match.winTip}')),
                        const VerticalDivider(),
                        TextButton(
                          child: const Text('More'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatchScreen(
                                        match: match)));
                          },
                        )
                      ],
                    )))));
  }
}
