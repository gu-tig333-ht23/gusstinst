// Class for creating chore objects with all parameters
class Chore {
  String text;

  String minute;
  String hour;
  String day;
  String month;
  String year;

  bool isDone;

  // empty strings as default if no user input when adding new chores
  Chore(this.text,
      {this.minute = '',
      this.hour = '',
      this.day = '',
      this.month = '',
      this.year = '',
      this.isDone = false}); // the chore is undone by default when created
}
