// class for creating FAQ objects
class FAQ {
  String question;
  String answer;

  FAQ(this.question, this.answer);
}

FAQ f1 = FAQ('Do I have to set a deadline for my chore?',
    'No, the deadline is optional. Leaving the fields empty will result in a chore marked with "No deadline".');

FAQ f2 = FAQ('How are the chores listed?',
    'All the chores are listed by their deadlines, these with the nearest upcoming deadlines will be shown at the top of the list. By using the filter in the top right corner, you can choose to show all chores, only the done ones or the undone ones.');

FAQ f3 = FAQ('What does the deadline colors mean?',
    'The colors assigned to each deadline shows how much time you have left to do them. Green color means two days or more or no deadline. Yellow color means less than two days left, orange color means less than four hours left and the dark red color means that the deadline has passed.');

FAQ f4 = FAQ('Can I edit my chores after they are created?',
    'Yes! By clicking on the chore text or the chore deadline, you will get a dialog window that allows you to edit the details as you wish.');

FAQ f5 = FAQ('How do I mark the chores as done?',
    'Each chore created has a checkbox at the left, by clicking it you can mark the chore as done or undone. Depending on the current filter, this can affect whether the chore is shown or not.');
// The list with all FAQ objects
List<FAQ> faqs = [f1, f2, f3, f4, f5];
