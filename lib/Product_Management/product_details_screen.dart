import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ft_engineering_admin/Components/reusable_widgets.dart';
import 'package:ft_engineering_admin/Product_Management/product_class.dart';

import 'add_product_screen.dart';


class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final String productId;

  ProductDetailsScreen({required this.product, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade200,
        title: Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product.imageUrl != null
                ? Image.network(
              widget.product.imageUrl!,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : const Icon(
              Icons.image_not_supported,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: ${widget.product.quantity} ${widget.product.quantityType}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${widget.product.price.toStringAsFixed(2)}',  // Display price properly
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReuseableButton(text: 'Edit', onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(
                        product: widget.product,
                        productId: widget.productId,
                        isUpdate: true,// Pass productId for edit
                      ),
                    ),
                  );
                },),
                ReuseableButton(text: 'Delete', onPressed: () => _deleteProduct(context, widget.productId),)
              ],
            ),
          ],
        ),
      ),
    ); 
  }

  void _deleteProduct(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('products').doc(productId).delete().then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Return to the previous screen
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
