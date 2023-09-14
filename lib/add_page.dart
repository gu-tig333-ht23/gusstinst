import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_list.dart';
import 'chore_item.dart';
import 'package:provider/provider.dart';

// View for adding new chores
class AddPage extends StatelessWidget {
  //final Function(Chore) addChore;
  // callback for adding new chores

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
        Text('Any deadline? (optional)'),

        // Year, month and day input fields in a row
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Year',
                  ),
                ),
              ),
              SizedBox(width: 5), // add some space between input fields
              Expanded(
                child: TextField(
                  controller: _monthController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Month',
                  ),
                ),
              ),
              SizedBox(width: 5), // add some space between input fields
              Expanded(
                child: TextField(
                  controller: _dayController,
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
        Text('Please use format 20YY/MM/DD  HH:MM'),

        // Hour and minute input fields in a row
        Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 3),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hourController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 10, left: 10),
                    labelText: 'Hour',
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: _minuteController,
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
              Provider.of<ChoreList>(context, listen: false).addChore(newChore);

              //addChore(newChore);
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
