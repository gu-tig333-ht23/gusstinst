import 'package:flutter/material.dart';

// View for adding new chores
class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
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
            onPressed: () {}, // does nothing rn
          ),
        ],
      ),
    );
  }
}
