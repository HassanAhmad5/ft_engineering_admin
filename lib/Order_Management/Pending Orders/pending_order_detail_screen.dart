import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../Provider/staff_provider.dart';

class PendingOrderDetailScreen extends StatefulWidget {
  final String orderId;
  final double totalPrice;
  final List<Map<String, dynamic>> products; // List of products in the order
  final String status;
  final DateTime orderDate;
  final String clientName;
  final String clientPhone;
  final String clientShop;
  final String clientAddress;
  final String clientArea;


  const PendingOrderDetailScreen({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.products,
    required this.status,
    required this.orderDate,
    required this.clientName, // Add clientId here
    required this.clientPhone, // Add clientId here
    required this.clientShop, // Add clientId here
    required this.clientAddress, // Add clientId here
    required this.clientArea, // Add clientId here
  });

  @override
  State<PendingOrderDetailScreen> createState() => _PendingOrderDetailScreenState();
}

class _PendingOrderDetailScreenState extends State<PendingOrderDetailScreen> {
  String? selectedStaffId;
  List<Map<String, dynamic>> staffMembers = []; // Store staff members

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data on initialization
  }

  Future<void> fetchData() async {
    QuerySnapshot staffSnapshot = await FirebaseFirestore.instance
        .collection('staff')
        .where('area_names', arrayContains: widget.clientArea) // Check if areaNames contains the areaName
        .get();

    staffMembers = staffSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // Refresh the UI
    setState(() {
      isLoading = false;
    });
  }

  Future<void> assignStaffToOrder(String staffId) async {
    await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
      'assigned_staffId': staffId,
      'status': 'in progress',
      'expense': []
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Staff member assigned to the order')),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final staffProvider = Provider.of<StaffProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade200,
        title: const Text(
          "Ft Engineering",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.02,
          horizontal: screenSize.width * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION 1: Order Details
              Text(
                'Order Details:',
                style: TextStyle(
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${widget.orderId}',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Order Date: ${widget.orderDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Status: ${widget.status}',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Products:',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.products.length,
                        itemBuilder: (context, index) {
                          final product = widget.products[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: screenSize.height * 0.1,
                                    width: screenSize.width * 0.2,
                                    child: Image.network(
                                      product['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'],
                                          style: TextStyle(
                                            fontSize: screenSize.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Quantity: ${product['quantity']}',
                                          style: TextStyle(
                                            fontSize: screenSize.width * 0.035,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Price: ${product['price'].toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: screenSize.width * 0.035,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Total Price: ${widget.totalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // SECTION 2: Client Details
              Text(
                'Client Details:',
                style: TextStyle(
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Client Name: ${widget.clientName}',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Phone: ${widget.clientPhone}',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Shop Name: ${widget.clientShop}',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Shop Address: ${widget.clientAddress}',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Area Name: ${widget.clientArea}',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Staff Members in the Same Area:',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else if (staffMembers.isNotEmpty) ...[
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: staffMembers.length,
                      itemBuilder: (context, index) {
                        final staffMember = staffMembers[index];
                        return RadioListTile<String>(
                          activeColor: Colors.black,
                          title: Text('Name: ${staffMember['name']}'),
                          subtitle: Text('Phone: ${staffMember['phone']}'),
                          value: staffMember['uid'], // Assuming 'uid' is the staff member's ID
                          groupValue: staffProvider.selectedStaffId,
                          onChanged: (value) {
                            staffProvider.setSelectedStaffId(value);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: staffProvider.selectedStaffId == null
                          ? null
                          : () async {
                        await assignStaffToOrder(staffProvider.selectedStaffId!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Assign Staff',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Center(
                  child: Text(
                    'No staff members available in this area',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ]




            ],
          ),
        ),
      ),
    );
  }
}
