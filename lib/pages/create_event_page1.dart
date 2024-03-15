import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/my_text_form_field2.dart';

class CreateEventPage1 extends StatefulWidget {
  const CreateEventPage1({super.key});

  @override
  State<CreateEventPage1> createState() => _CreateEventPage1State();
}

class _CreateEventPage1State extends State<CreateEventPage1> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _townCityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  int noOfPeople = 2;
  DateTime selectedDate = DateTime.now();

  // get formatted date
  String getFormattedDate() {
    return DateFormat('dd-MM-yyyy - h:mm a').format(selectedDate);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // use MediaQuery to get the screen size for responsive padding
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.09,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                children: [
                  Text(
                    "Let's get your event registered",
                    style: TextStyle(fontSize: screenHeight * 0.04),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                  MyTextFormField2(
                    controller: _descriptionController,
                    labelText: 'Description',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 2,
                  ),

                  // date and time
                  SizedBox(height: screenHeight * 0.004),
                  ListTile(
                    title: Text(
                      getFormattedDate(),
                      style: const TextStyle(fontSize: 17),
                    ),
                    leading: const Icon(Icons.date_range_rounded),
                    onTap: () => _selectDateTime(context),
                  ),

                  // no of people
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.person),
                        SizedBox(width: screenWidth * 0.01),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (noOfPeople > 2) noOfPeople--;
                            });
                          },
                        ),
                        Text(
                          '$noOfPeople',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              noOfPeople++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.004),

                  TextField(
                    controller: _addressLine1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Address line 1',
                    ),
                  ),
                  TextField(
                    controller: _addressLine2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Address line 2',
                    ),
                  ),

                  TextField(
                    controller: _townCityController,
                    decoration: InputDecoration(
                      labelText: 'Town/City',
                    ),
                  ),
                  TextField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(
                      labelText: 'Postcode',
                    ),
                  ),

                ],
              ),
            ),
          ),

          // button for navigating to review event details and create event
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02), // this ensures the button is visible above any system UI at the bottom of the screen.
            child: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/createEvent2'),
              child: const Icon(Icons.arrow_forward),
            ),
          ),
    );
  }
}