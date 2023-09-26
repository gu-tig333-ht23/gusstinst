// Class for creating chore objects with all parameters
class Chore {
  String? id;
  String text;

  String year;
  String month;
  String day;
  String hour;
  String minute;

  bool isDone;

  // zeroes in strings as default deadline if no user input when adding new chores
  Chore(this.text,
      {this.id,
      this.year = '0000',
      this.month = '00',
      this.day = '00',
      this.hour = '00',
      this.minute = '00',
      this.isDone = false}); // the chore is undone by default when created

  // converting json to Chore objects
  factory Chore.fromJson(Map<String, dynamic> json) {
    final parts = json['title'].split('/');

    return Chore(
      parts[0],
      id: json['id'], // chore text
      year: parts[1],
      month: parts[2],
      day: parts[3],
      hour: parts[4],
      minute: parts[5],
      isDone: json['done'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": '$text/$year/$month/$day/$hour/$minute',
      "done": isDone,
    };
  }
}
