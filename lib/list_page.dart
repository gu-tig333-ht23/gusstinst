import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';

// view to receive and show chores
class ListPage extends StatelessWidget {
  final List<Chore> Function() getChores;

  // handles the deleteChore function
  //final Function(Chore) deleteChore;
  // handles the toggleBox function
  //final Function(Chore) toggleBox;
  // handles the editChoreText function
  //final Function(Chore, String) editChoreText;
  // handles the editChoreDeadline function
  //final Function(Chore, String) editChoreDeadline;

  ListPage(
    this.getChores,
  );

  @override
  Widget build(BuildContext context) {
    final filteredChores = getChores();
    // secures that itemCount isn`t below 0
    final itemCount =
        filteredChores.isEmpty ? 0 : filteredChores.length * 2 - 1;

    return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final choreIndex = index ~/ 2;
          if (index.isEven) {
            if (choreIndex < filteredChores.length) {
              return Column(
                children: [
                  ChoreItem(
                    filteredChores[choreIndex],
                  ),
                ],
              );
            }
          }
          return Divider(); // Display a Divider for odd indices
        });
  }
}
