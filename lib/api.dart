import 'chore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// All API functions here

// Endpoint
const String api = 'https://todoapp-api.apps.k8s.gu.se';
// API Key
const String apiKey = 'e88119ce-f54f-457c-bcb2-07bc332b2c45';

Future<List<Chore>> getChoresFromAPI() async {
  http.Response response = await http.get(Uri.parse('$api/todos?key=$apiKey'));
  String body = response.body;
  List<dynamic> jsonResponse = jsonDecode(body);
  List<Chore> jsonChores =
      jsonResponse.map((json) => Chore.fromJson(json)).toList();
  return jsonChores;
}

// add new chore to API
Future<bool> addChoreToAPI(Chore chore) async {
  try {
    final response = await http.post(
      Uri.parse('$api/todos?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(chore.toJson()),
    );

    if (response.statusCode == 200) {
      // API call is successful
      return true;
    } else {
      // API call failed
      return false;
    }
  } catch (error) {
    print('Network error: $error');
    return false;
  }
}

// delete a chore from API by ID
Future<bool> deleteChoreFromAPI(String id) async {
  try {
    final response = await http.delete(Uri.parse('$api/todos/$id?key=$apiKey'));

    if (response.statusCode == 200) {
      // successful API call
      return true;
    } else {
      return false;
    }
  } catch (error) {
    // if network fails
    print('Network error: $error');
    return false;
  }
}

// update chore status in API
Future<bool> updateAPIStatus(String id, Chore chore) async {
  bool status = !chore
      .isDone; // retrieves the chores actual status true/false AFTER toggling according to its current status
  Chore updatedChore = Chore(chore.text, isDone: status);
  try {
    final response = await http.put(Uri.parse('$api/todos/$id?key=$apiKey'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedChore
            .toJson())); // put the new chore in, replacing the old one with same ID

    if (response.statusCode == 200) {
      // API call is successful
      return true;
    } else {
      // API call failed
      return false;
    }
  } catch (error) {
    // if the network fails
    print('Network error: $error');
    return false;
  }
}

// update chore deadline and/or text in API
Future<bool> updateAPIChore(String id, Chore chore, {String? newText}) async {
  String text = newText ??
      chore.text; // if no new choretext is provided, keep the current
  bool status = chore.isDone; // retrieving current chore parameters
  String m = chore.minute;
  String h = chore.hour;
  String d = chore.day;
  String mo = chore.month;
  String y = chore.year;

  if (newText != null) {
    text = newText;
  }

  Chore editedDeadlineChore = Chore(text,
      minute: m, hour: h, day: d, month: mo, year: y, isDone: status);

  try {
    // creates a new chore with the changed deadline and the other parameters stays the same
    final response = await http.put(Uri.parse('$api/todos/$id?key=$apiKey'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(editedDeadlineChore
            .toJson())); // put the new chore in, replacing the old one with same ID
    if (response.statusCode == 200) {
      // API call is successful
      return true;
    } else {
      // API call failed
      return false;
    }
  } catch (error) {
    // if network fails
    print('Network error: $error');
    return false;
  }
}
