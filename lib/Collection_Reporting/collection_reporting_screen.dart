import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CollectionReportingScreen extends StatefulWidget {
  const CollectionReportingScreen({super.key});

  @override
  State<CollectionReportingScreen> createState() => _CollectionReportingScreenState();
}

class _CollectionReportingScreenState extends State<CollectionReportingScreen> {

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _startDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
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
        }
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
        lastDate: DateTime(2101),
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
        }
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text = DateFormat('dd-MM-yyyy').format(picked); // Formatting the date
      });
    }
  }

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
                    Text("Total Collection", style: TextStyle(fontSize: 23),),
                    Text("10000\$", style: TextStyle(fontSize: 20, color: Colors.blueAccent),)
                  ],
                ),
              ),

            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.05 * MediaQuery.of(context).size.width),
                child: Row(
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
                    title: Text('Collection #${index+1}'),
                    subtitle: const Text('Details of Collection'),
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
