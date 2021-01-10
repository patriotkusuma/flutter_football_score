class TeamModel{
  String  idTeam;
  String  strTeamBadge;

  TeamModel({this.idTeam, this.strTeamBadge});

  Map<String, dynamic> toMap(){
    return{
      'idTeam':idTeam,
      'strTeamBadge':strTeamBadge,
    };
  }
}