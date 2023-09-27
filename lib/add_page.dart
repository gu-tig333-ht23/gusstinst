import 'package:flutter/material.dart';
import 'package:template/main.dart';
import 'chore.dart';
import 'chore_list.dart';
import 'package:provider/provider.dart';
import 'date_time_provider.dart';
import 'package:intl/intl.dart';

// View for adding new chores
// ignore: must_be_immutable
class AddPage extends StatelessWidget {
  // controllers for saving text input when adding new chores
  final TextEditingController _textController = TextEditingController();

  // building AddPage
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DateTimeProvider(),
      child: Builder(builder: (context) {
        final dateTimeProvider = Provider.of<DateTimeProvider>(context);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'What are you going to do?',
                ),
              ),
            ),
            Text('Any deadline? (optional)'),
            SizedBox(height: 10),
            // Year, month and day input fields in a row
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 5),
                        );
                        if (selectedDate != null) {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: TimeOfDay.now().hour + 2,
                              minute: TimeOfDay.now().minute,
                            ),
                          );
                          if (selectedTime != null) {
                            dateTimeProvider.updateSelectedDateTime(
                                selectedDate, selectedTime);
                          }
                        }
                      },
                      child: Text('Select Date'),
                    ),
                  ),

                  SizedBox(width: 5), // add some space between input fields
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: TimeOfDay.now().hour + 2,
                              minute: TimeOfDay.now().minute,
                            ));
                        if (selectedTime != null) {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 5),
                          );
                          if (selectedDate != null) {
                            dateTimeProvider.updateSelectedDateTime(
                              selectedDate,
                              selectedTime,
                            );
                          }
                        }
                      },
                      child: Text('Select Time'),
                    ),
                  ),
                ],
              ),
            ),
            Selector<DateTimeProvider, DateTime>(
              selector: (context, provider) => provider.selectedDateTime,
              builder: (context, selectedDateTime, child) {
                return Column(
                  children: [
                    Text(
                        'Selected Date and Time: ${dateTimeProvider.selectedDateTime == DateTime(0000, 00, 00, 00, 00) ? "No deadline" : DateFormat.yMd().add_Hm().format(dateTimeProvider.selectedDateTime)}'),
                    ElevatedButton(
                      onPressed: () {
                        dateTimeProvider.updateSelectedDateTime(
                            DateTime(0000, 00, 00, 00, 00),
                            TimeOfDay(hour: 00, minute: 00));
                      },
                      child: Text('Reset deadline'),
                    )
                  ],
                );
              },
            ),

            SizedBox(height: 10),
            FloatingActionButton.extended(
              icon: Icon(Icons.add),
              label: Text('ADD'),
              onPressed: () {
                // Gets the entered chore text from the input field
                String choreText = _textController.text;
                DateTime selectedDateTime = dateTimeProvider.selectedDateTime;

                if (choreText.isNotEmpty) {
                  // Creates a new chore object
                  Chore newChore = Chore(
                    choreText,
                    year: selectedDateTime.year ==
                            -1 // DateTime does not accept 0000 as valid year
                        ? '0000'
                        : selectedDateTime.year.toString(),
                    month: selectedDateTime.year == -1
                        ? '00'
                        : selectedDateTime.month.toString().padLeft(2, '0'),
                    day: selectedDateTime.year == -1
                        ? '00'
                        : selectedDateTime.day.toString().padLeft(2, '0'),
                    hour: selectedDateTime.hour.toString().padLeft(2, '0'),
                    minute: selectedDateTime.minute.toString().padLeft(2, '0'),
                  );

                  // Adds chore to the chores list
                  Provider.of<ChoreList>(context, listen: false)
                      .addNewChore(newChore);
                }
                // Clears the input fields
                _textController.clear();
                // Back to "main page" after adding a chore
                Provider.of<MyAppState>(context, listen: false).setIndex(0);
              },
            ),
            SizedBox(height: 10),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('What does the deadline colors mean?'),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 2, left: 8, right: 8),
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green),
                    padding: EdgeInsets.all(4),
                    child: Text(
                        'Chill                          >2 days left/No deadline'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 2, left: 8, right: 8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.yellow),
                    padding: EdgeInsets.all(4),
                    child: Text(
                        'Move on                                         <2 days left'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 2, left: 8, right: 8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange),
                    padding: EdgeInsets.all(4),
                    child: Text(
                        'Hurry                                            <4 hours left'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 2, left: 8, right: 8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 79, 8, 3)),
                    padding: EdgeInsets.all(4),
                    child: Text(
                        'Late                                        deadline passed',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
