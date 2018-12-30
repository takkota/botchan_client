class PushSchedule {
  int botId;
  DateTime scheduleTime;
  List<DAY> days;

  PushSchedule({this.botId, this.scheduleTime, this.days = const []});
}
enum DAY {
  MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

String convertDayToString(DAY day) {
  String dayStr;
  switch (day) {
    case DAY.MONDAY:
      dayStr = "月";
      break;
    case DAY.TUESDAY:
      dayStr = "火";
      break;
    case DAY.WEDNESDAY:
      dayStr = "水";
      break;
    case DAY.THURSDAY:
      dayStr = "木";
      break;
    case DAY.FRIDAY:
      dayStr = "金";
      break;
    case DAY.SATURDAY:
      dayStr = "土";
      break;
    case DAY.SUNDAY:
      dayStr = "日";
      break;
  }
  return dayStr;
}

int convertDayToBitFlag(List<DAY> days) {
  int bitFlag = 0;
  days.forEach((day) {
    switch (day) {
      case DAY.MONDAY:
        bitFlag += 1;
        break;
      case DAY.TUESDAY:
        bitFlag += 2;
        break;
      case DAY.WEDNESDAY:
        bitFlag += 4;
        break;
      case DAY.THURSDAY:
        bitFlag += 8;
        break;
      case DAY.FRIDAY:
        bitFlag += 16;
        break;
      case DAY.SATURDAY:
        bitFlag += 32;
        break;
      case DAY.SUNDAY:
        bitFlag += 64;
        break;
    }
  });
  return bitFlag;
}
