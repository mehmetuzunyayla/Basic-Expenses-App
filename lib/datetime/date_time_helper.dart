// convert dateTime object to a string yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
  //year
  String year = dateTime.year.toString();
  //month
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  //day
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  //date
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
