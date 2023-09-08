class Chore {
  String text;

  final String minute;
  final String hour;
  final String day;
  final String month;
  final String year;

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
