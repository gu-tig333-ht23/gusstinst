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

  String minute;
  String hour;
  String day;
  String month;
  String year;

  bool isDone;

  // empty strings as default if no user input when adding new chores
  Chore(this.text,
      {this.minute = '00',
      this.hour = '00',
      this.day = '00',
      this.month = '00',
      this.year = '0000',
      this.id,
      this.isDone = false}); // the chore is undone by default when created

  // converting json to Chore objects
  factory Chore.fromJson(Map<String, dynamic> json) {
    final parts = json['title'].split('/');

    return Chore(parts[0],
        id: json['id'],
        isDone: json['done'],
        minute: parts[1],
        hour: parts[2],
        day: parts[3],
        month: parts[4],
        year: parts[5]);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": '$text/$minute/$hour/$day/$month/$year',
      "done": isDone,
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
  await http.post(
    Uri.parse('$api/todos?key=$apiKey'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(chore.toJson()),
  );
}

// delete a chore from API by ID
Future<void> deleteChoreFromAPI(String id) async {
  await http.delete(Uri.parse('$api/todos/$id?key=$apiKey'));
}

// update the chore text in API
Future<void> updateChoreTextInAPI(
    String id, Chore chore, String newText) async {
  bool status = chore.isDone;
  Chore editedChore = Chore(newText,
      isDone:
          status); // creates a new chore with the changed text and same status
  await http.put(Uri.parse('$api/todos/$id?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(editedChore
          .toJson())); // put the new chore in, replacing the old one with same ID
}

// update chore status in API
Future<void> updateAPIStatus(String id, Chore chore) async {
  bool status = chore
      .isDone; // retrieves the chores actual status true/false after toggling
  Chore updatedChore = Chore(chore.text, isDone: status);
  await http.put(Uri.parse('$api/todos/$id?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedChore
          .toJson())); // put the new chore in, replacing the old one with same ID
}
