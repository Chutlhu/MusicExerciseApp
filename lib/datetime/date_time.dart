// return today data as yyyymmdd
String todayDateYYYYMMDD() {
 
  var dateTimeObject = DateTime.now();

  // year in the format yyyy
  String year = dateTimeObject.year.toString();

  // month in the format mm
  String month = dateTimeObject.month.toString();

  // day in the format dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

// convert string yyyymmdd to DateTime object
DateTime createDateTimeObject(String yyyymmdd) {
  int year = int.parse(yyyymmdd.substring(0, 4));
  int month = int.parse(yyyymmdd.substring(4, 6));
  int day = int.parse(yyyymmdd.substring(6, 8));

  return DateTime(year, month, day);
}

// convert DateTime object to string yyyymmdd
String convertDateTimeToYYYYMMDD(DateTime dateTimeObject) {
  // year in the format yyyy
  String year = dateTimeObject.year.toString();

  // month in the format mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day in the format dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}