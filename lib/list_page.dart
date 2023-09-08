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

  final Function(Chore, String) editChoreText;

  ListPage(this.chores,
      {required this.deleteChore,
      required this.toggleBox,
      required this.editChoreText});

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
                ChoreItem(
                  chores[choreIndex],
                  deleteChore: deleteChore,
                  toggleBox: toggleBox,
                  editChoreText: editChoreText,
                ),
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
