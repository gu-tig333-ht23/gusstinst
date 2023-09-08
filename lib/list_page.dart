import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';

// view to receive and show chores
class ListPage extends StatelessWidget {
  final List<Chore> chores;

  // handles the deleteChore function
  final Function(Chore) deleteChore;

  ListPage(this.chores, {required this.deleteChore});

  @override
  Widget build(BuildContext context) {
    final itemCount = chores.isEmpty ? 0 : chores.length * 2 - 1;

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index.isEven) {
          final choreIndex = index ~/ 2;
          if (choreIndex < chores.length) {
            return Column(
              children: [
                ChoreItem(chores[choreIndex], deleteChore: deleteChore)
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
