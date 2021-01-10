import 'package:flutter/material.dart';
import 'package:football_live_score/models/last_model.dart';
import 'package:football_live_score/models/team_model.dart';
import 'package:football_live_score/screens/detail_last.dart';
import 'package:football_live_score/widgets/Last_list.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  var database;

  List<LastModel> lastModels = List<LastModel>();

  Future initDb() async{
    database = openDatabase(
    join(await getDatabasesPath(), 'favorite.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE last_match(idEvent TEXT PRIMATY KEY,  strHomeTeam TEXT, strAwayTeam TEXT, intHomeScore TEXT, intAwayScore TEXT, dateEvent TEXT, strHomeGoalDetails TEXT, strHomeLineupGoalkeeper TEXT,  strHomeFormation TEXT, strAwayGoalDetails TEXT,  strAwayLineupGoalkeeper TEXT,strAwayFormation TEXT, idHomeTeam TEXT, idAwayTeam TEXT)",
      );
    },
    version: 1,
    );

    getMatchList().then((value){
      setState(() {
        lastModels = value;
      });
    });
  }


  Future<List<LastModel>> getMatchList() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('last_match');

    return List.generate(maps.length, (i) {
      return LastModel(
        dateEvent: maps[i]['dateEvent'],
        idHomeTeam: maps[i]['idHomeTeam'],
        idAwayTeam: maps[i]['idAwayTeam'],
        idEvent: maps[i]['idEvent'],
        intAwayScore: maps[i]['intAwayScore'],
        intHomeScore: maps[i]['intHomeScore'],
        strAwayFormation: maps[i]['strAwayFormation'],
        strAwayGoalDetails: maps[i]['strAwayGoalDetails'],
        strAwayLineupGoalkeeper: maps[i]['strAwayLineupGoalkeeper'],
        strAwayTeam: maps[i]['strAwayTeam'],
        strHomeFormation: maps[i]['strHomeFormation'],
        strHomeGoalDetails: maps[i]['strHomeGoalDetails'],
        strHomeTeam: maps[i]['strHomeTeam'],
        strHomeLineupGoalkeeper: maps[i]['strHomeLineupGoalkeeper'],
      );
    });

    //prin
  }

  Future<void> deleteLastMatch(String idEvent) async {
    final db = await database;
    await db.delete(
      'last_match',
      where: 'idEvent=?',
      whereArgs: [idEvent],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: SafeArea(
        child: Column(
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
                        child: LinearProgressIndicator(),
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
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            child: IconButton(
                                              icon: Icon(FontAwesomeIcons.trash),
                                              onPressed: (){
                                                SweetAlert.show(
                                                    context,
                                                    title: "Yakin ?",
                                                    showCancelButton: true,
                                                    style: SweetAlertStyle.confirm,
                                                    onPress: (isConfirm) {
                                                      if(isConfirm){

                                                        deleteLastMatch(snapshot.data[index].idEvent).then((value){
                                                          getMatchList().then((value){
                                                            setState(() {
                                                              lastModels = value;
                                                            });
                                                          });
                                                        });
                                                        SweetAlert.show(
                                                            context,
                                                            title: "Deleted Successfully!",
                                                            style: SweetAlertStyle.success,
                                                        );

                                                        return false;
                                                      }
                                                    },
                                                );
                                              },
                                            ),
                                          )
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
        ),
      ),
    );
  }
}