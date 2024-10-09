import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Completed Orders/completed_order_detail_screen.dart';
import 'Pending Orders/pending_order_detail_screen.dart';
import 'Progress Orders/progress_order_detail_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int pendingOrdersCount = 0;
  int inProgressOrdersCount = 0;
  int completeOrdersCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrderCounts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to fetch orders with specific status
  Stream<QuerySnapshot> getOrdersByStatus(String status) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: status)
        .orderBy('orderDate', descending: true)// Order by 'orderDate' in descending order
        .snapshots();
  }


  void _fetchOrderCounts() {
    getOrdersByStatus('pending').listen((snapshot) {
      setState(() {
        pendingOrdersCount = snapshot.docs.length;
      });
    });

    getOrdersByStatus('in progress').listen((snapshot) {
      setState(() {
        inProgressOrdersCount = snapshot.docs.length;
      });
    });

    getOrdersByStatus('completed').listen((snapshot) {
      setState(() {
        completeOrdersCount = snapshot.docs.length;
      });
    });
  }

  Future<Map<String, dynamic>?> getClientData(String clientId) async {
    DocumentSnapshot clientSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(clientId).get();
    if (clientSnapshot.exists) {
      return clientSnapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade200,
        title: const Text(
          "Ft Engineering",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display total orders
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 0.10 * MediaQuery.of(context).size.width),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Orders",
                    style: TextStyle(fontSize: 23),
                  ),
                  Text(
                    "${pendingOrdersCount + inProgressOrdersCount + completeOrdersCount}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  )
                ],
              ),
            ),
          ),
          // TabBar with order counts
          TabBar(
            indicatorColor: Colors.yellow.shade600,
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Pending ($pendingOrdersCount)'),
              Tab(text: 'In Progress ($inProgressOrdersCount)'),
              Tab(text: 'Completed ($completeOrdersCount)'),
            ],
          ),
          // Make only TabBarView scrollable
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildPendingOrderList(),    // Pending orders tab
                buildProgressOrderList(),  // In progress orders tab
                buildCompletedOrderList(),   // Completed orders tab
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPendingOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrdersByStatus('pending'), // Modify the stream to order by 'orderDate' descending
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.black));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No orders available'),
          );
        }

        var orders = snapshot.data!.docs;

        return SingleChildScrollView( // Scroll only the order list
          child: Column(
            children: List.generate(orders.length, (index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              String orderId = orders[index].id;
              String clientId = orderData['clientId'];
              double totalPrice = orderData['totalPrice'];
              List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(orderData['products']);
              DateTime orderDate = (orderData['orderDate'] as Timestamp).toDate();

              return FutureBuilder<Map<String, dynamic>?>(
                future: getClientData(clientId), // Assuming this fetches the client data
                builder: (context, clientSnapshot) {
                  if (clientSnapshot.connectionState == ConnectionState.waiting) {
                    // Show a placeholder for the client data while waiting for it to load
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        title: Text('Order ID: $orderId'),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Client: Loading...'),
                            Text('Shop: Loading...'),
                            Text('Products: Loading...'),
                            Text('Total Price: Loading...'),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!clientSnapshot.hasData) {
                    return const Center(child: Text('Client details not found'));
                  }

                  var clientData = clientSnapshot.data!;
                  String clientName = clientData['name'];
                  String clientShop = clientData['shop_name'];
                  String clientPhone = clientData['phone'];
                  String clientAddress = clientData['shop_address'];
                  String clientArea = clientData['area_name'];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: ListTile(
                      title: Text('Order ID: $orderId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Client: $clientName'),
                          Text('Shop: $clientShop'),
                          Text('Products: ${products.length}'),
                          Text('Total Price: ${totalPrice.toStringAsFixed(0)}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PendingOrderDetailScreen(
                              orderId: orderId,
                              totalPrice: totalPrice,
                              products: products,
                              orderDate: orderDate,
                              status: 'pending',
                              clientName: clientName,
                              clientPhone: clientPhone,
                              clientShop: clientShop,
                              clientAddress: clientAddress,
                              clientArea: clientArea,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  Widget buildProgressOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrdersByStatus('in progress'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No orders available'),
          );
        }

        var orders = snapshot.data!.docs;

        return SingleChildScrollView(
          child: Column(
            children: List.generate(orders.length, (index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              String orderId = orders[index].id;
              String clientId = orderData['clientId'];
              String staffId = orderData['assigned_staffId'];
              double totalPrice = orderData['totalPrice'];
              List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(orderData['products']);
              DateTime orderDate = (orderData['orderDate'] as Timestamp).toDate();

              return FutureBuilder<Map<String, dynamic>?>(
                future: getClientData(clientId), // Fetch client data
                builder: (context, clientSnapshot) {
                  if (clientSnapshot.connectionState == ConnectionState.waiting) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        title: Text('Order ID: $orderId'),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Client: Loading...'),
                            Text('Shop: Loading...'),
                            Text('Products: Loading...'),
                            Text('Total Price: Loading...'),
                            Text('Staff: Loading...'),
                            Text('Phone: Loading...'),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!clientSnapshot.hasData) {
                    return const Center(child: Text('Client details not found'));
                  }

                  var clientData = clientSnapshot.data!;
                  String clientName = clientData['name'];
                  String clientShop = clientData['shop_name'];
                  String clientPhone = clientData['phone'];
                  String clientAddress = clientData['shop_address'];
                  String clientArea = clientData['area_name'];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('staff').doc(staffId).get(), // Fetch staff data
                    builder: (context, staffSnapshot) {
                      if (staffSnapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: ListTile(
                            title: Text('Order ID: $orderId'),
                            subtitle: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Client: Loading...'),
                                Text('Shop: Loading...'),
                                Text('Products: Loading...'),
                                Text('Total Price: Loading...'),
                                Text('Staff: Loading...'),
                                Text('Phone: Loading...'),
                              ],
                            ),
                          ),
                        );
                      }

                      if (!staffSnapshot.hasData) {
                        return const Center(child: Text('Staff details not found'));
                      }

                      var staffData = staffSnapshot.data!.data() as Map<String, dynamic>;
                      String staffName = staffData['name'];
                      String staffPhone = staffData['phone'];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          title: Text('Order ID: $orderId'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Client: $clientName'),
                              Text('Shop: $clientShop'),
                              Text('Products: ${products.length}'),
                              Text('Total Price: ${totalPrice.toStringAsFixed(0)}'),
                              Text('Staff: $staffName'),
                              Text('Phone: $staffPhone'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgressOrderDetailScreen(
                                  orderId: orderId,
                                  totalPrice: totalPrice,
                                  products: products,
                                  orderDate: orderDate,
                                  status: 'in progress',
                                  clientName: clientName,
                                  clientPhone: clientPhone,
                                  clientShop: clientShop,
                                  clientAddress: clientAddress,
                                  clientArea: clientArea,
                                  staffName: staffName,
                                  staffPhone: staffPhone,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  Widget buildCompletedOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrdersByStatus('completed'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No orders available'),
          );
        }

        var orders = snapshot.data!.docs;

        return SingleChildScrollView(
          child: Column(
            children: List.generate(orders.length, (index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              String orderId = orders[index].id;
              String clientId = orderData['clientId'];
              String staffId = orderData['assigned_staffId'];
              double totalPrice = orderData['totalPrice'];
              List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(orderData['products']);
              DateTime orderDate = (orderData['orderDate'] as Timestamp).toDate();
              List<Map<String, dynamic>> expenses = List<Map<String, dynamic>>.from(orderData['expense']);

              return FutureBuilder<Map<String, dynamic>?>(
                future: getClientData(clientId), // Fetch client data
                builder: (context, clientSnapshot) {
                  if (clientSnapshot.connectionState == ConnectionState.waiting) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        title: Text('Order ID: $orderId'),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Client: Loading...'),
                            Text('Shop: Loading...'),
                            Text('Products: Loading...'),
                            Text('Total Price: Loading...'),
                            Text('Staff: Loading...'),
                            Text('Phone: Loading...'),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!clientSnapshot.hasData) {
                    return const Center(child: Text('Client details not found'));
                  }

                  var clientData = clientSnapshot.data!;
                  String clientName = clientData['name'];
                  String clientShop = clientData['shop_name'];
                  String clientPhone = clientData['phone'];
                  String clientAddress = clientData['shop_address'];
                  String clientArea = clientData['area_name'];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('staff').doc(staffId).get(), // Fetch staff data
                    builder: (context, staffSnapshot) {
                      if (staffSnapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: ListTile(
                            title: Text('Order ID: $orderId'),
                            subtitle: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Client: Loading...'),
                                Text('Shop: Loading...'),
                                Text('Products: Loading...'),
                                Text('Total Price: Loading...'),
                                Text('Staff: Loading...'),
                                Text('Phone: Loading...'),
                              ],
                            ),
                          ),
                        );
                      }

                      if (!staffSnapshot.hasData) {
                        return const Center(child: Text('Staff details not found'));
                      }

                      var staffData = staffSnapshot.data!.data() as Map<String, dynamic>;
                      String staffName = staffData['name'];
                      String staffPhone = staffData['phone'];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          title: Text('Order ID: $orderId'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Client: $clientName'),
                              Text('Shop: $clientShop'),
                              Text('Products: ${products.length}'),
                              Text('Total Price: ${totalPrice.toStringAsFixed(0)}'),
                              Text('Staff: $staffName'),
                              Text('Phone: $staffPhone'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompletedOrderDetailScreen(
                                  orderId: orderId,
                                  totalPrice: totalPrice,
                                  products: products,
                                  orderDate: orderDate,
                                  status: 'completed',
                                  clientName: clientName,
                                  clientPhone: clientPhone,
                                  clientShop: clientShop,
                                  clientAddress: clientAddress,
                                  clientArea: clientArea,
                                  staffName: staffName,
                                  staffPhone: staffPhone,
                                  expense: expenses,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }


}

