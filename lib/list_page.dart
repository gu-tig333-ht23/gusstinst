import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_item.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'chore_list.dart';

// view to list/show chores
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
          return chores.where((chore) => chore.isDone == true).toList();
        case FilterItem.undone:
          return chores.where((chore) => chore.isDone == false).toList();
        default:
          return chores;
      }
    }

    // get the current list according to filters
    final filteredChores = getFilteredChores();
    // sorts the chores in the list according to their deadlines
    //Provider.of<ChoreList>(context, listen: false).sortChoresByDeadline();

    // secures that itemCount isn`t below 0
    final itemCount =
        filteredChores.isEmpty ? 0 : filteredChores.length * 2 - 1;

    if (currentFilter == FilterItem.all && filteredChores.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'You have no chores! Create a new one by clicking the checkbox-icon in the navigation rail!'),
          ),
        ],
      );
    } else if (currentFilter == FilterItem.done && filteredChores.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('You haven`t fulfilled any chores yet. Get them done!'),
          ),
        ],
      );
    } else if (currentFilter == FilterItem.undone && filteredChores.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('You have done it all! Hooray!'),
          ),
        ],
      );
    }
    return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final choreIndex = index ~/ 2;
          if (index.isEven) {
            if (choreIndex < filteredChores.length) {
              return ChoreItem(filteredChores[choreIndex], choreIndex);
            }
          }
          return Divider(); // Display a Divider for odd indices
        });
  }
}
