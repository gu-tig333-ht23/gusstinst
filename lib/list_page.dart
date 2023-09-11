import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';

// view to receive and show chores
class ListPage extends StatelessWidget {
  final List<Chore> chores;

  // handles the deleteChore function
  final Function(Chore) deleteChore;

  // handles the toggleBox function
  final Function(Chore) toggleBox;
  // handles the editChoreText function
  final Function(Chore, String) editChoreText;
  // handles the editChoreDeadline function
  final Function(Chore, String) editChoreDeadline;

  ListPage(this.chores,
      {required this.deleteChore,
      required this.toggleBox,
      required this.editChoreText,
      required this.editChoreDeadline});

  @override
  Widget build(BuildContext context) {
    // secures that itemCount isn`t below 0
    final itemCount = chores.isEmpty ? 0 : chores.length * 2 - 1;

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index.isEven) {
          final choreIndex = index ~/ 2;
          if (choreIndex < chores.length) {
            return Column(
              children: [
                ChoreItem(chores[choreIndex],
                    deleteChore: deleteChore,
                    toggleBox: toggleBox,
                    editChoreText: editChoreText,
                    editChoreDeadline: editChoreDeadline),
              ],
            );
          }
        }
        return Divider(); // Display a Divider for odd indices
      },
      itemCount: itemCount,
    );
  }
}
