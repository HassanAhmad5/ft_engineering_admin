import 'package:flutter/material.dart';

class ProgressOrderDetailScreen extends StatelessWidget {
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
  final String staffName;
  final String staffPhone;

  const ProgressOrderDetailScreen({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.products,
    required this.status,
    required this.orderDate,
    required this.clientName,
    required this.clientPhone,
    required this.clientShop,
    required this.clientAddress,
    required this.clientArea,
    required this.staffName,
    required this.staffPhone,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
                        'Order ID: $orderId',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Order Date: ${orderDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          color: status == 'completed' ? Colors.green : Colors.orange,
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
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
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
                          'Total Price: ${totalPrice.toStringAsFixed(0)}',
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
                          'Client Name: $clientName',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Phone: $clientPhone',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Shop Name: $clientShop',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Shop Address: $clientAddress',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Area: $clientArea',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SECTION 3: Staff Details
              Text(
                'Staff Details:',
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
                          'Staff Name: $staffName',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Phone: $staffPhone',
                          style: TextStyle(fontSize: screenSize.width * 0.04),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
