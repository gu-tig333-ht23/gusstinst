class Chore {
  final String text;

  final String minute;
  final String hour;
  final String day;
  final String month;
  final String year;

  Chore(this.text,
      {this.minute = '59',
      this.hour = '23',
      this.day = '31',
      this.month = '12',
      this.year = '2040'});
}
