import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
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
      body: Expanded(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 0.05 * MediaQuery.of(context).size.width,
          ),
          itemCount: 10, // Update this with the actual count of stock items
          itemBuilder: (context, index) {
            // Replace this with your custom list item
            return ListTile(
              title: Text('Reminder #${index+1}'),
              subtitle: const Text('Details of Reminder'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle item click
              },
            );
          },
        ),
      ),
    );
  }
}
