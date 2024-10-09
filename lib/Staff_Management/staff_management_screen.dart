import 'package:flutter/material.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
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
                  Text("Total Staff", style: TextStyle(fontSize: 23),),
                  Text("10", style: TextStyle(fontSize: 20, color: Colors.blueAccent),)
                ],
              ),
            ),

          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.05 * MediaQuery.of(context).size.width),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Staff',
                prefixIcon: const Icon(Icons.search),
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey, // Normal border color
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.black, // Color of the border when focused
                    width: 2.0, // Optional: Adjust the width of the focused border
                  ),
                ),
              ),
              onChanged: (value) {
                // Handle search logic here
              },
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
                  title: Text('Staff #${index+1}'),
                  subtitle: const Text('Details of Staff'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle item click
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
