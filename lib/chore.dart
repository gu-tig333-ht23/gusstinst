import 'package:http/http.dart' as http;
import 'dart:convert';

// Endpoint
const String api = 'https://todoapp-api.apps.k8s.gu.se';
// API Key
const String apiKey = '8a68cedb-e3f7-42c7-a0b0-a9547d962017';

// Class for creating chore objects with all parameters
class Chore {
  String? id;
  String text;

  //String minute;
  //String hour;
  //String day;
  //String month;
  //String year;

  bool isDone;

  // empty strings as default if no user input when adding new chores
  Chore(this.text,
      /*{this.minute = '',
      this.hour = '',
      this.day = '',
      this.month = '',
      this.year = '',*/
      {this.id,
      this.isDone = false}); // the chore is undone by default when created

  // converting json to Chore objects
  factory Chore.fromJson(Map<String, dynamic> json) {
    return Chore(json['title'], id: json['id'], isDone: json['done']
        //minute: json['minute'],
        //hour: json['hour'],
        //day: json['day'],
        //month: json['month'],
        //year: json['year'],
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": text,
      "done": isDone,
      //"minute": minute,
      //"hour": hour,
      //"day": day,
      //"month": month,
      //"year": year,
    };
  }
}

Future<List<Chore>> getChoresFromAPI() async {
  http.Response response = await http.get(Uri.parse('$api/todos?key=$apiKey'));
  String body = response.body;
  List<dynamic> jsonResponse = jsonDecode(body);
  List<Chore> jsonChores =
      jsonResponse.map((json) => Chore.fromJson(json)).toList();
  return jsonChores;
}

// add new chore to API
Future<void> addChoreToAPI(Chore chore) async {
  http.Response response = await http.post(
    Uri.parse('$api/todos?key=$apiKey'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(chore.toJson()),
  );
}

// delete a chore from API by ID
Future<void> deleteChoreFromAPI(String id) async {
  http.Response response =
      await http.delete(Uri.parse('$api/todos/$id?key=$apiKey'));
}

// update the chore text in API
Future<void> updateChoreTextInAPI(String id, String newText) async {
  Chore editedChore =
      Chore(newText); // creates a new chore with the changed text
  await http.put(Uri.parse('$api/todos/$id?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(editedChore
          .toJson())); // put the new chore in, replacing the old one with same ID
}

// update chore status in API
Future<void> updateAPIStatus(String id) async {}
