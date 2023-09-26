import 'package:flutter/material.dart';
import 'package:template/main.dart';
import 'chore.dart';
import 'chore_list.dart';
import 'package:provider/provider.dart';

// View for adding new chores
// ignore: must_be_immutable
class AddPage extends StatelessWidget {
  // controllers for saving text input when adding new chores
  final TextEditingController _textController = TextEditingController();

  String _selectedYear = '0000'; // default values
  String _selectedMonth = '00'; // will result in chore with "No deadline"
  String _selectedDay = '00';
  String _selectedHour = '00';
  String _selectedMinute = '00';

  final List<String> yearOptions = ['0000', '2023', '2024', '2025', '2026'];

  final List<String> monthOptions = List.generate(13, (index) {
    return (index).toString().padLeft(2, '0');
  });

  final List<String> dayOptions = List.generate(32, (index) {
    return (index).toString().padLeft(2, '0');
  });

  final List<String> hourOptions = List.generate(24, (index) {
    return index.toString().padLeft(2, '0');
  });

  final List<String> minuteOptions = List.generate(60, (index) {
    return index.toString().padLeft(2, '0');
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
              labelText: 'What are you going to do?',
            ),
          ),
        ),
        Text('Any deadline? (optional)'),
        SizedBox(height: 10),
        // Year, month and day input fields in a row
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedYear,
                  onChanged: (value) {
                    _selectedYear = value!;
                  },
                  items:
                      yearOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Year',
                  ),
                ),
              ),
              SizedBox(width: 5), // add some space between input fields
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  onChanged: (value) {
                    _selectedMonth = value!;
                  },
                  items: monthOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Month',
                  ),
                ),
              ),
              SizedBox(width: 5), // add some space between input fields
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDay,
                  onChanged: (value) {
                    _selectedDay = value!;
                  },
                  items:
                      dayOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Day',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        // Hour and minute input fields in a row
        Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 3),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedHour,
                  onChanged: (value) {
                    _selectedHour = value!;
                  },
                  items:
                      hourOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Hour',
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedMinute,
                  onChanged: (value) {
                    _selectedMinute = value!;
                  },
                  items: minuteOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Minute',
                  ),
                ),
              ),
              SizedBox(width: 100), // pushing the input fields to leftmost side
            ],
          ),
        ),
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('ADD'),
          onPressed: () {
            // Gets the entered chore text from the input field
            String choreText = _textController.text;
            String choreYear = _selectedYear;
            String choreMonth = _selectedMonth;
            String choreDay = _selectedDay;
            String choreHour = _selectedHour;
            String choreMinute = _selectedMinute;

            if (choreText.isNotEmpty) {
              // Creates a new chore object
              Chore newChore = Chore(
                choreText,
                minute: choreMinute,
                hour: choreHour,
                day: choreDay,
                month: choreMonth,
                year: choreYear,
              );

              // Adds chore to the chores list
              Provider.of<ChoreList>(context, listen: false)
                  .addNewChore(newChore);
            }
            // Clears the input fields
            _textController.clear();
            // Back to "main page" after adding a chore
            Provider.of<MyAppState>(context, listen: false).setIndex(0);
          },
        ),
        SizedBox(height: 10),

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('What does the deadline colors mean?'),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8.0, bottom: 2, left: 8, right: 8),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green),
                padding: EdgeInsets.all(4),
                child: Text('Chill                 >2 days left/No deadline'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8.0),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.yellow),
                padding: EdgeInsets.all(4),
                child:
                    Text('Move on                                <2 days left'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8.0),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange),
                padding: EdgeInsets.all(4),
                child: Text(
                    'Hurry                                    <4 hours left'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8.0),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 79, 8, 3)),
                padding: EdgeInsets.all(4),
                child: Text(
                    'Late                                deadline passed',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
