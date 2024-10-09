import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTrackingScreen extends StatefulWidget {
  const ExpenseTrackingScreen({super.key});

  @override
  State<ExpenseTrackingScreen> createState() => _ExpenseTrackingScreenState();
}

class _ExpenseTrackingScreenState extends State<ExpenseTrackingScreen> {

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Header background color
            colorScheme: ColorScheme.light(
              primary: Colors.yellow.shade200, // Header text color
              onPrimary: Colors.black, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.accent, // Button text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startDateController.text = DateFormat('dd-MM-yyyy').format(picked); // Formatting the date
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(), // End date cannot be before start date
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Header background color
            colorScheme: ColorScheme.light(
              primary: Colors.yellow.shade200, // Header text color
              onPrimary: Colors.black, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent, // Button text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text = DateFormat('dd-MM-yyyy').format(picked); // Formatting the date
      });
    }
  }

  final List<String> _expenseCategories = [
    'Food & Dining',
    'Transport',
    'Shopping',
    'Entertainment',
    'Medical',
    'Utilities',
    'Rent',
    'Insurance',
  ];

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade200,
          title: const Text("Ft Engineering", style: TextStyle(
              fontWeight: FontWeight.bold
          ),),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 0.10 * MediaQuery.of(context).size.width ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Expenses", style: TextStyle(fontSize: 23),),
                    Text("10000\$", style: TextStyle(fontSize: 20, color: Colors.blueAccent),)
                  ],
                ),
              ),

            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.05 * MediaQuery.of(context).size.width
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 0.4 * MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: _startDateController,
                          decoration: InputDecoration(
                            hintText: 'Start Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey, // Normal border color
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.black, // Color of the border when focused
                                width: 2.0, // Optional: Adjust the width of the focused border
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectStartDate(context);
                              },
                            ),
                          ),
                          readOnly: true, // Make the TextField non-editable
                          onTap: () {
                            _selectStartDate(context); // Open the date picker on tap
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.4 * MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: _endDateController,
                          decoration: InputDecoration(
                            hintText: 'End Date',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey, // Normal border color
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.black, // Color of the border when focused
                                width: 2.0, // Optional: Adjust the width of the focused border
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectEndDate(context);
                                // Open the date picker
                              },
                            ),
                          ),
                          readOnly: true, // Make the TextField non-editable
                          onTap: () {
                            _selectEndDate(context); // Open the date picker on tap
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.grey, // Normal border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.black, // Color of the border when focused
                          width: 2.0, // Optional: Adjust the width of the focused border
                        ),
                      ),
                    ),
                    value: _selectedCategory, // Initial value
                    icon: Icon(Icons.arrow_drop_down), // Dropdown icon
                    items: _expenseCategories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue; // Update selected item
                      });
                    },
                    hint: Text('Expense Category'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.05 * MediaQuery.of(context).size.width,
                ),
                itemCount: 10, // Update this with the actual count of stock items
                itemBuilder: (context, index) {
                  // Replace this with your custom list item
                  return ListTile(
                    title: Text('Expense #${index+1}'),
                    subtitle: const Text('Details of Expense'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle item click
                    },
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}
