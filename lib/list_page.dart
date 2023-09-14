import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'chore_list.dart';

// view to receive and show chores
class ListPage extends StatelessWidget {
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

    // get the current list according to filters
    final filteredChores = getFilteredChores();
    // sorts the chores in the list according to their deadlines
    Provider.of<ChoreList>(context, listen: false).sortChoresByDeadline();

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
