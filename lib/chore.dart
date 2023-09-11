class Chore {
  String text;

  String minute;
  String hour;
  String day;
  String month;
  String year;

  bool isDone;

  // empty strings as default if no user input
  Chore(this.text,
      {this.minute = '',
      this.hour = '',
      this.day = '',
      this.month = '',
      this.year = '',
      this.isDone = false});
}
