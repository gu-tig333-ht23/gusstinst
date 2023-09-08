import 'package:flutter/material.dart';
import 'chore.dart';

// View for adding new chores
class AddPage extends StatelessWidget {
  final Function(Chore) addChore;
  // callback for adding new chores
  AddPage(this.addChore);

  // controllers for saving text input when adding new chores
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

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
        Text('Any deadline?'),
        Text('Please use format 2023/5/2  23:59'),
        TextField(
          controller: _yearController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(right: 10, left: 10),
            labelText: 'Year',
          ),
        ),
        TextField(
          controller: _monthController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(right: 10, left: 10),
            labelText: 'Month',
          ),
        ),
        TextField(
          controller: _dayController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(right: 10, left: 10),
            labelText: 'Day',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _hourController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(right: 10, left: 10),
              labelText: 'Hour',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _minuteController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(right: 10, left: 10),
              labelText: 'Minute',
            ),
          ),
        ),
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('ADD'),
          onPressed: () {
            // Gets the entered chore text from the input field
            String choreText = _textController.text;
            String choreYear = _yearController.text;
            String choreMonth = _monthController.text;
            String choreDay = _dayController.text;
            String choreHour = _hourController.text;
            String choreMinute = _minuteController.text;

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
              addChore(newChore);
            }
            // Clears the input fields
            _textController.clear();
            _yearController.clear();
            _monthController.clear();
            _dayController.clear();
            _hourController.clear();
            _minuteController.clear();
          },
        ),
      ],
    );
  }
}
