import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';

// view to receive and show chores
class ListPage extends StatelessWidget {
  final List<Chore> chores;

  ListPage(this.chores);

  @override
  Widget build(BuildContext context) {
    /*
    List<Chore> chores = [
      Chore('Clean bathroom'),
      Chore('Fix the computer'),
      Chore('Do homework'),
      Chore('Vacuum bedroom'),
      Chore('Walk the dog'),
      Chore('Workout'),
      Chore('Grocery shopping'),
      Chore('Make the bed'),
      Chore('Make dinner'),
      Chore('Buy more wine'),
      Chore('Wash the car'),
      Chore('Help grandma'),
      Chore('Laundry'),
      Chore('Feed the cat')
    ];
*/
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < chores.length) {
          return Column(
            children: [
              ChoreItem(chores[index]),
              Divider(),
            ],
          );
        } else {
          return null;
        }
      },
      itemCount: chores.length * 2 - 1,
    );
  }
}
