import 'package:flutter/material.dart';

import 'match_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        titleSpacing: 0,
        title: Card(
          color: Theme.of(context).primaryColor,
            child:Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                },icon:const Icon(Icons.arrow_back)),
                const Expanded(child:TextField(
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    
                  ),
                )),
                const IconButton(onPressed: null, icon: Icon(Icons.search))
              ],
            )
          ),
      ),
      body: 
     ListView(
              
        children: const [
          // MatchCard(
          //   time:'17:00',
          //   home: 'Germany',
          //   away: 'England',
          //   winTip:'1'
          // ),
          // MatchCard(
          //   time:'17:00',
          //   home: 'Germany',
          //   away: 'England',
          //   winTip:'1'
          // ),
          // MatchCard(
          //   time:'17:00',
          //   home: 'Germany',
          //   away: 'England',
          //   winTip:'1'
          // )
        ],
      ),
    );
  }
}