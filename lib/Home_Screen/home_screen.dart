
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Collection_Reporting/collection_reporting_screen.dart';
import '../Components/reusable_widgets.dart';
import '../Expense_Tracking/expense_tracking_screen.dart';
import '../Location_Tracking/location_tracking_screen.dart';
import '../Order_Management/order_management_screen.dart';
import '../Payment_Receiving/payment_receiving_screen.dart';
import '../Product_Management/product_management_screen.dart';
import '../Reminders/reminder_screen.dart';
import '../Staff_Management/staff_management_screen.dart';
import '../Stock_Management/stock_management_screen.dart';
import '../Vendor_Management/vendor_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade200,
          title: const Text("Ft Engineering", style: TextStyle(
              fontWeight: FontWeight.bold
          ),),
          leading: const SizedBox(),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert), // Three vertical dots icon
              onSelected: (value) {
                if (value == 0) {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  });
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ReusableContainer(icon: Icons.production_quantity_limits, text: "Products Management", onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductManagementScreen()));
                      },),
                      ReusableContainer(icon: Icons.people_alt, text: "Vendor Management", onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorManagementScreen()));
                      },),
                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReusableContainer(icon: Icons.collections, text: "Collection Reporting", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CollectionReportingScreen()));
                    },),
                    ReusableContainer(icon: Icons.attach_money_rounded, text: "Expense Tracking", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseTrackingScreen()));
                    },)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReusableContainer(icon: Icons.add_location, text: "Location Tracking", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationTrackingScreen()));
                    },),
                    ReusableContainer(icon: Icons.content_paste, text: "Order Management", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderManagementScreen()));
                    },)

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReusableContainer(icon: Icons.payment_outlined, text: "Payment Receiving", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentReceivingScreen()));
                    },),
                    ReusableContainer(icon: Icons.access_time_outlined, text: "Reminders", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReminderScreen()));
                    },),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReusableContainer(icon: Icons.people_rounded, text: "Staff Management", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffManagementScreen()));
                    },),
                    ReusableContainer(icon: Icons.content_paste, text: "Stock Management", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const StockManagementScreen()));
                    },),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}



