import 'package:flutter/material.dart';
import 'chore.dart';

// View for adding new chores
class AddPage extends StatelessWidget {
  final Function(Chore) addChore;
  // callback for adding new chores
  AddPage(this.addChore);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
              labelText: 'What are you going to do?',
            ),
          ),
        ),
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('ADD'),
          onPressed: () {
            // Gets the entered chore text from the input field
            String choreText = _controller.text;
            print(choreText);
            // Creates a new chore object
            Chore newChore = Chore(choreText);
            // Adds chore to the list
            addChore(newChore);
            // Clears the input field
            _controller.clear();
          },
        ),
      ],
    );
  }
}
