class ReplyCondition {
  int botId;
  String keyword;
  MatchMethod matchMethod;

  ReplyCondition({this.botId, this.keyword = "", this.matchMethod = MatchMethod.PARTIAL});
}
enum MatchMethod {
  PARTIAL, EXACT
}
