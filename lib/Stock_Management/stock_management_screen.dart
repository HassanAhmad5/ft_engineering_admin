import 'package:flutter/material.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
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
          Padding(
            padding: EdgeInsets.all(0.05 * MediaQuery.of(context).size.width),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search stock items',
                prefixIcon: const Icon(Icons.search), // Equivalent to startIconDrawable
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
                // Implement search functionality here
              },
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(0.05 * MediaQuery.of(context).size.width),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Items: 0', // Update this with dynamic data
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Low Stock Items: 0', // Update this with dynamic data
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0.05 * MediaQuery.of(context).size.width),
              itemCount: 10, // Update this with the actual count of stock items
              itemBuilder: (context, index) {
                // Replace this with your custom list item
                return ListTile(
                  title: Text('Stock Item #$index'),
                  subtitle: const Text('Details or stock count'),
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
