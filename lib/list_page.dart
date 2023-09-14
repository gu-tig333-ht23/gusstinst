import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'chore_list.dart';

// view to receive and show chores
class ListPage extends StatelessWidget {
  // handles the editChoreText function
  //final Function(Chore, String) editChoreText;
  // handles the editChoreDeadline function
  //final Function(Chore, String) editChoreDeadline;

  //ListPage();

  @override
  Widget build(BuildContext context) {
    var chores = context.watch<ChoreList>().chores;
    var currentFilter = context.watch<MyAppState>().selectedFilter;

    List<Chore> getFilteredChores() {
      switch (currentFilter) {
        case FilterItem.all:
          return chores;
        case FilterItem.done:
          return Provider.of<ChoreList>(context, listen: false)
              .filterDoneChores(chores);
        case FilterItem.undone:
          return Provider.of<ChoreList>(context, listen: false)
              .filterUndoneChores(chores);
        default:
          return chores;
      }
    }

    final filteredChores = getFilteredChores();

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
                  ChoreItem(filteredChores[choreIndex]),
                ],
              );
            }
          }
          return Divider(); // Display a Divider for odd indices
        });
  }
}
