import 'package:flutter/material.dart';
import 'package:template/main.dart';
import 'chore.dart';
import 'chore_list.dart';
import 'package:provider/provider.dart';
import 'date_time_provider.dart';
import 'package:intl/intl.dart';

// View for adding new chores
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

        // function to show date picker
        Future<void> createDate() async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 5),
          );
          if (selectedDate != null) {
            dateTimeProvider.updateSelectedDate(selectedDate);
          }
        }

        // function to show time picker
        Future<void> createTime() async {
          final selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: TimeOfDay.now().hour + 2,
              minute: TimeOfDay.now().minute,
            ),
          );
          if (selectedTime != null) {
            dateTimeProvider.updateSelectedTime(selectedTime);
          }
        }

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
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            Text('Any deadline? (optional)',
                style: TextStyle(color: Colors.black, fontSize: 16)),
            SizedBox(height: 10),
            // Year, month and day input fields in a row
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        createDate();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.inversePrimary),
                      ),
                      child: Text('Select Date',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ),

                  SizedBox(width: 5), // add some space between input fields
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        createTime();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.inversePrimary),
                      ),
                      child: Text('Select Time',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
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
                    ElevatedButton(
                      onPressed: () {
                        dateTimeProvider.updateSelectedDateTime(
                            DateTime(0000, 00, 00, 00, 00),
                            TimeOfDay(hour: 00, minute: 00));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.inversePrimary),
                      ),
                      child: Text('Reset deadline',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    ),
                    Text(
                      'Selected Date and Time:',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                        ' ${dateTimeProvider.selectedDateTime == DateTime(0000, 00, 00, 00, 00) ? "No deadline" : DateFormat.yMd().add_Hm().format(dateTimeProvider.selectedDateTime)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                );
              },
            ),

            SizedBox(height: 15),
            FloatingActionButton.extended(
              icon: Icon(Icons.add),
              label: Text('ADD',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () async {
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

                  bool apiresponse = await
                      // Adds chore to the chores list
                      Provider.of<ChoreList>(context, listen: false)
                          .addNewChore(newChore);
                  if (apiresponse) {
                    await Provider.of<ChoreList>(context, listen: false)
                        .fetchChores();
                  }
                }
                // Clears the input fields
                _textController.clear();
                // Back to "main page" after adding a chore
                Provider.of<MyAppState>(context, listen: false).setIndex(0);
              },
            ),
          ],
        );
      }),
    );
  }
}
