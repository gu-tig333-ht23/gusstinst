import 'chore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// All API functions here

// Endpoint
const String api = 'https://todoapp-api.apps.k8s.gu.se';
// API Key
const String apiKey = '8a68cedb-e3f7-42c7-a0b0-a9547d962017';

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
  bool status = chore.isDone; // retrieving current chore parameters
  String y = chore.year;
  String mo = chore.month;
  String d = chore.day;
  String h = chore.hour;
  String m = chore.minute;

  Chore editedChore = Chore(newText,
      year: y,
      month: mo,
      day: d,
      hour: h,
      minute: m,
      isDone:
          status); // creates a new chore with the changed text and same status and other parameters stays the same
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

// update chore deadline in API
Future<void> updateAPIDeadline(String id, Chore chore) async {
  String text = chore.text;
  bool status = chore.isDone; // retrieving current chore parameters
  String m = chore.minute;
  String h = chore.hour;
  String d = chore.day;
  String mo = chore.month;
  String y = chore.year;

  Chore editedDeadlineChore = Chore(text,
      minute: m,
      hour: h,
      day: d,
      month: mo,
      year: y,
      isDone:
          status); // creates a new chore with the changed deadline and the other parameters stays the same
  await http.put(Uri.parse('$api/todos/$id?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(editedDeadlineChore
          .toJson())); // put the new chore in, replacing the old one with same ID
}