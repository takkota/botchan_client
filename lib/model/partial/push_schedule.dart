class PushSchedule {
  int id;
  int botId;
  DateTime scheduleTime;
  List<DAY> days;

  PushSchedule({this.id, this.botId, this.scheduleTime, this.days = const []});

  static int convertDaysToBitFlag(List<DAY> days) {
    int total = 0;
    days.forEach((day) {
      switch (day) {
        case DAY.MONDAY:
          total += 1;
          break;
        case DAY.TUESDAY:
          total += 2;
          break;
        case DAY.WEDNESDAY:
          total += 4;
          break;
        case DAY.THURSDAY:
          total += 8;
          break;
        case DAY.FRIDAY:
          total += 16;
          break;
        case DAY.SATURDAY:
          total += 32;
          break;
        case DAY.SUNDAY:
          total += 64;
          break;
      }
    });
    return total;
  }

  static List<DAY> convertBitFlagToDays(int bitFlag) {
    List<DAY> matchedDays = List();
    DAY.values.forEach((day) {
      switch (day) {
        case DAY.MONDAY:
          if (bitFlag & 1 == 1) {
            matchedDays.add(day);
          }
          break;
        case DAY.TUESDAY:
          if (bitFlag & 2 == 2) {
            matchedDays.add(day);
          }
          break;
        case DAY.WEDNESDAY:
          if (bitFlag & 4 == 4) {
            matchedDays.add(day);
          }
          break;
        case DAY.THURSDAY:
          if (bitFlag & 8 == 8) {
            matchedDays.add(day);
          }
          break;
        case DAY.FRIDAY:
          if (bitFlag & 16 == 16) {
            matchedDays.add(day);
          }
          break;
        case DAY.SATURDAY:
          if (bitFlag & 32 == 32) {
            matchedDays.add(day);
          }
          break;
        case DAY.SUNDAY:
          if (bitFlag & 64 == 64) {
            matchedDays.add(day);
          }
          break;
      }
    });
    return matchedDays;
  }

  static String convertDayToString(DAY day) {
    String dayStr = "";
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

}

enum DAY {
  MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

