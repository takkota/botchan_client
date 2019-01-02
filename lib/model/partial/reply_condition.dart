class ReplyCondition {
  int id;
  int botId;
  String keyword;
  MatchMethod matchMethod;

  ReplyCondition({this.id, this.botId, this.keyword = "", this.matchMethod = MatchMethod.PARTIAL});
}
enum MatchMethod {
  PARTIAL, EXACT
}
