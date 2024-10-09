import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ft_engineering_admin/Authentication/login.dart';
import 'package:ft_engineering_admin/Home_Screen/home_screen.dart';
import 'package:ft_engineering_admin/Product_Management/product_management_screen.dart';
import 'package:provider/provider.dart';

import 'Firebase/firebase_options.dart';
import 'Order_Management/Provider/staff_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => StaffProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  const LoginScreen(),
        '/login': (context) => const LoginScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          // Outline border settings
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          // Focused border settings
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black, width: 2.0), // Color and width for focused border
          ),
          // Label style when unfocused
          labelStyle: const TextStyle(color: Colors.grey),
          // Label style when focused
          floatingLabelStyle: const TextStyle(color: Colors.black),
          // Hint text style
          hintStyle: const TextStyle(color: Colors.grey),
          // Prefix and suffix text style
          prefixStyle: const TextStyle(color: Colors.black),
          suffixStyle: const TextStyle(color: Colors.black),
        ),
      ),

    );
  }
}