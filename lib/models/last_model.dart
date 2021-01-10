class LastModel{
  String idEvent;
  String strHomeTeam;
  String strAwayTeam;
  String intHomeScore;
  String intAwayScore;
  String dateEvent;
  String strHomeGoalDetails;
  String strHomeLineupGoalkeeper;
  String strHomeFormation;
  String strAwayGoalDetails;
  String strAwayLineupGoalkeeper;
  String strAwayFormation;
  String idHomeTeam;
  String idAwayTeam;

  LastModel({
    this.idEvent, this.strHomeTeam, this.strAwayTeam, this.intHomeScore, this.intAwayScore, this.dateEvent, this.strHomeGoalDetails,
    this.strHomeLineupGoalkeeper,  this.strHomeFormation, this.strAwayGoalDetails,  this.strAwayLineupGoalkeeper,
     this.strAwayFormation, this.idHomeTeam, this.idAwayTeam
  });

  Map<String, dynamic> toMap(){
    return{
      'idEvent':idEvent,
      'strHomeTeam':strHomeTeam,
      'intHomeScore': intHomeScore,
      'intAwayScore': intAwayScore,
      'dateEvent': dateEvent,
      'strHomeGoalDetails': strHomeGoalDetails,
      'strHomeLineupGoalkeeper': strHomeLineupGoalkeeper,
      'strAwayLineupGoalkeeper': strAwayLineupGoalkeeper,
      'strAwayFormation': strAwayFormation,
      'idAwayTeam': idAwayTeam,
      'idHomeTeam': idHomeTeam,
    };
  }
}