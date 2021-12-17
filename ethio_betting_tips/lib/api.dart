class API {
  List<MatchTip> getAllMatchs(){
    return [
      MatchTip('Germany','England','17:00',1,2.5,true),
      MatchTip('Ethiopia','Ghana','19:00',0,-2.5,false)
    ];
  }
  List<MatchTip> getMatchsForResult(String term){
    return [
      MatchTip('Germany','England','17:00',1,2.5,false)
    ];
  }
}
class MatchTip{
  MatchTip(this.home,this.away,this.time,this.winTip,this.overUnderTip,this.gGTip,{this.homeRecord=const [-2,-2,-2,-2,-2],this.awayRecord=const [-2,-2,-2,-2,-2]});
  final String home;
  final String away;
  final String time;
  final List<int> homeRecord;
  final List<int> awayRecord;
  final int winTip;
  final double overUnderTip;
  final bool gGTip;

}