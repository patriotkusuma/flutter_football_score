import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_live_score/models/last_model.dart';
import 'package:football_live_score/screens/detail_last.dart';
import 'package:http/http.dart' as http;

class LastMatch extends StatelessWidget {
  final String idLeague;
  LastMatch(this.idLeague);

  Future<List<LastModel>> getMatchList() async{
    var url = "https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id=$idLeague";
    var data = await http.get(url);

    var jsonData = jsonDecode(data.body)['events'] as List;
    final List<LastModel> lastModels = [];

    for (var t in jsonData) {
      LastModel lastModel = LastModel(
        idEvent: t['idEvent'],
        dateEvent: t['dateEvent'],
        intAwayScore: t['intAwayScore'],
        intHomeScore: t['intHomeScore'],
        strAwayFormation: t['strAwayFormation'],
        strAwayGoalDetails: t['strAwayGoalDetails'],
        strAwayLineupGoalkeeper: t['strAwaLineupGoalkeeper'],
        strAwayTeam: t['strAwayTeam'],
        strHomeFormation: t['strHomeFormation'],
        strHomeGoalDetails: t['strHomeGoalDetails'],
        strHomeLineupGoalkeeper: t['strHomeLineupGoalkeeper'],
        strHomeTeam: t['strHomeTeam'],
        idAwayTeam: t['idAwayTeam'],
        idHomeTeam: t['idHomeTeam'],
      );
      lastModels.add(lastModel);
    }

    return lastModels;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Match List",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 8.0,),
        Container(
          height: 500,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: FutureBuilder(
            future: getMatchList(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }else{
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context, 
                          new MaterialPageRoute(
                            builder: (context) => DetailLastMatch(snapshot.data[index]),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(6),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0,2),
                              blurRadius: 2
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data[index].strHomeTeam == null ? '' : snapshot.data[index].strHomeTeam,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800
                                      ),
                                    ),
                                    ],
                                  ) ,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(snapshot.data[index].intHomeScore == null ? '' : snapshot.data[index].intHomeScore,
                                      style: TextStyle(
                                        color: Colors.blue[400],
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].dateEvent == null ? '' : snapshot.data[index].dateEvent,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "VS",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].intAwayScore == null ? '' : snapshot.data[index].intAwayScore,
                                        style: TextStyle(
                                          color: Colors.blue[400],
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(snapshot.data[index].strAwayTeam == null ? '' : snapshot.data[index].strAwayTeam,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}