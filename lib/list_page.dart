import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';

// view to show chores
class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    return ListView.builder(
      itemBuilder: (context, index) {
        //return _chore(context, chores[index % chores.length]);
        return ChoreItem(chores[index]);
      },
      itemCount: chores.length,
    );
  }
}
