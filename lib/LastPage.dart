import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_live_score/models/league_model.dart';
import 'package:football_live_score/widgets/Last_list.dart';
import 'package:http/http.dart' as http;

class LastPage extends StatefulWidget {
  @override
  _LastPageState createState() => _LastPageState();
}

class _LastPageState extends State<LastPage> {
  String idLeague = "4329";
  int selectedIndex = 1;
  var selectedValue;

  Future<List<LeagueModel>> getLeague() async{
    var url = "https://www.thesportsdb.com/api/v1/json/1/all_leagues.php";
    var data = await http.get(url);

    var jsonData = jsonDecode(data.body)['leagues'] as List;

    final List<LeagueModel> leagues = [];

    for (var val in jsonData){
      if(val['strSport'] == 'Soccer'){
        LeagueModel league = LeagueModel(
          idLeague: val['idLeague'],
          strLeague: val['strLeague'],
          strSport: val['strSport']
        );
        leagues.add(league);
      }
    }

    return leagues;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last Match'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40.0,
                                child: FutureBuilder(
                                  future: getLeague(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (snapshot.data == null) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:BorderRadius.circular(25),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:CrossAxisAlignment.center,
                                            mainAxisAlignment:MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Loading...",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder:(BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                                idLeague = snapshot.data[index].idLeague;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Container(
                                                width: 200,
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: selectedIndex == index? Colors.blue : Colors.grey[300],
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.center,
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      snapshot.data[index].strLeague,
                                                      style: TextStyle(
                                                        color: selectedIndex ==index? Colors.white70: Colors.black45,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        LastMatch(idLeague),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
