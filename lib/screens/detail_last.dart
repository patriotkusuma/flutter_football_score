import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_live_score/models/last_model.dart';
import 'package:football_live_score/models/team_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DetailLastMatch extends StatefulWidget {
  final LastModel _lastModel;
  DetailLastMatch(this._lastModel);

  @override
  _DetailLastMatchState createState() => _DetailLastMatchState();
}

class _DetailLastMatchState extends State<DetailLastMatch> {
  // var strAwayBadge, strHomeBadge;
  var badge;
  var database;

  Future<List<TeamModel>> getBadge(String idTeam) async{
    var url = "https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id=$idTeam";
    var data = await http.get(url);

    var jsonData = jsonDecode(data.body)['teams'] as List;
    final List<TeamModel> teams = [];
    for(var t in jsonData){
      TeamModel team = TeamModel(
        idTeam: t['idTeam'],
        strTeamBadge: t['strTeamBadge'],
      );
      teams.add(team);
    }
    return teams;
  }

  @override
  void initState(){
    super.initState();
    initDb();
  }

  Future initDb() async{
    database = openDatabase(
      join(await getDatabasesPath(), 'favorite.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE last_match(idEvent TEXT PRIMATY KEY,  strHomeTeam TEXT, strAwayTeam TEXT, intHomeScore TEXT, intAwayScore TEXT, dateEvent TEXT, strHomeGoalDetails TEXT, strHomeLineupGoalkeeper TEXT,  strHomeFormation TEXT, strAwayGoalDetails TEXT,  strAwayLineupGoalkeeper TEXT,strAwayFormation TEXT, idHomeTeam TEXT, idAwayTeam TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertLastMatch(LastModel lastModel) async{
    final Database db = await database;
    await db.insert("last_match", lastModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Match'),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 16),
            icon: Icon(Icons.favorite),
            onPressed: (){
              insertLastMatch(widget._lastModel);
              SweetAlert.show(
                context,
                style: SweetAlertStyle.success,
                title: "Added to Favorite"
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context){
          if(widget._lastModel==null){
            return CircularProgressIndicator();
          }
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16,),
                height: 550,
                alignment: Alignment.center,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20),
                //   color: Colors.black54,
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black87,
                //       offset: Offset(0 , 2),
                //       blurRadius: 2
                //     )
                //   ],
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget._lastModel.dateEvent == null ? '' : widget._lastModel.dateEvent,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500
                      ),                    
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(widget._lastModel.intHomeScore == null ? '' : widget._lastModel.intHomeScore,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 65,
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
                              Text("VS",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 80,
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
                              Text(widget._lastModel.intAwayScore == null ? '' : widget._lastModel.intAwayScore,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 65,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            ],
                          ) ,
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: 150,
                                child: FutureBuilder(
                                  future: getBadge(widget._lastModel.idHomeTeam == null ? '' : widget._lastModel.idHomeTeam),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.data == null){
                                      return CircularProgressIndicator();
                                    }
                                    return Image.network(snapshot.data[0].strTeamBadge == null ? '' : snapshot.data[0].strTeamBadge);
                                  },
                                ),
                              ),
                              SizedBox(height: 16,),
                              Container(
                                alignment: Alignment.center,
                                width: 150,
                                child: Text(widget._lastModel.strHomeTeam == null ? '' : widget._lastModel.strHomeTeam,
                                style: TextStyle(
                                  color: Colors.blue[400],
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ),
                              
                            ],
                          ) ,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: 150,
                                child: FutureBuilder(
                                  future: getBadge(widget._lastModel.idAwayTeam == null ? '' : widget._lastModel.idAwayTeam),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.data == null){
                                      return CircularProgressIndicator();
                                    }
                                    return Image.network(snapshot.data[0].strTeamBadge == null ? '' : snapshot.data[0].strTeamBadge);
                                  },
                                ),
                              ),
                              SizedBox(height: 16,),
                              Container(
                                alignment: Alignment.center,
                                width: 150,
                                child: Text(widget._lastModel.strAwayTeam == null ? '' : widget._lastModel.strAwayTeam,
                                style: TextStyle(
                                  color: Colors.blue[400],
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ),
                              
                            ],
                          ) ,
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(widget._lastModel.strHomeGoalDetails == null ? '' : widget._lastModel.strHomeGoalDetails ,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 20,
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
                              Text("Goal",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
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
                              Text(widget._lastModel.strAwayGoalDetails == null ? '' : widget._lastModel.strAwayGoalDetails,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 20,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            ],
                          ) ,
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(widget._lastModel.strHomeLineupGoalkeeper == null? '' : widget._lastModel.strHomeLineupGoalkeeper ,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 20,
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
                              Text("Goal Keeper",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
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
                              Text(widget._lastModel.strAwayLineupGoalkeeper == null ? '' : widget._lastModel.strAwayLineupGoalkeeper,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 20,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            ],
                          ) ,
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(widget._lastModel.strHomeFormation == null? '' : widget._lastModel.strHomeFormation ,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 20,
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
                              Text("Formation",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
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
                              Text(widget._lastModel.strAwayFormation == null ? '' : widget._lastModel.strAwayFormation,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 20,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            ],
                          ) ,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}