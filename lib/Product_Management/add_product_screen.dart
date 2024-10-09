import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:ft_engineering_admin/Product_Management/product_class.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../Components/reusable_widgets.dart';
import '../Utils/Utilities.dart';

class AddProductScreen extends StatefulWidget {
  final bool isUpdate; // Determines if the action is 'add' or 'update'
  final Product product;
  final String productId;

  AddProductScreen({
    super.key,
    required this.product,
    required this.productId,
    required this.isUpdate,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productDescription = '';
  int productQuantity = 0;
  String quantityType = 'KG';
  File? _image;
  final List<String> quantityTypes = ['KG', 'Piece', 'Box'];
  double productPrice = 0.0;


  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('products');

  final picker = ImagePicker();

  @override
  void initState() {
    if (widget.isUpdate) {
      // If updating, populate form fields with product data
      productName = widget.product.name;
      productDescription = widget.product.description;
      productQuantity = widget.product.quantity;
      quantityType = widget.product.quantityType;
      productPrice = widget.product.price;
    }
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      firebase_storage.UploadTask uploadTask = ref.putFile(image);
      await uploadTask.whenComplete(() {});

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      try {
        String? imageUrl = widget.product.imageUrl; // Keep old image if not changed

        if (_image != null) {
          imageUrl = await _uploadImage(_image!);

          if (imageUrl == null) {
            Utilities().errorMsg('Image upload failed');
            setState(() {
              isLoading = false;
            });
            return;
          }
        }

        if (widget.isUpdate) {
          // Update existing product
          await productsCollection.doc(widget.productId).update({
            'name': productName,
            'description': productDescription,
            'quantity': productQuantity,
            'quantityType': quantityType,
            'imageUrl': imageUrl ?? '',
            'price': productPrice,  // Include price here
            'timestamp': FieldValue.serverTimestamp(),
          });

          Utilities().successMsg("Product Updated Successfully");
          widget.product.name = productName;
          widget.product.description = productDescription;
          widget.product.quantity = productQuantity;
          widget.product.quantityType = quantityType;
          widget.product.price = productPrice;  // Update product price
        } else {
          // Add new product
          await productsCollection.add({
            'name': productName,
            'description': productDescription,
            'quantity': productQuantity,
            'quantityType': quantityType,
            'imageUrl': imageUrl ?? '',
            'price': productPrice,  // Include price here
            'timestamp': FieldValue.serverTimestamp(),
          });

          Utilities().successMsg("Product Added Successfully");
        }


        Navigator.pop(context);
      } catch (e) {
        print('Failed to save product details: $e');
        Utilities().errorMsg('Failed to save product');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
        padding: EdgeInsets.all(screenSize.width * 0.05), // Responsive padding
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.isUpdate ? productName : '', // Handle add/update form data
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
                onSaved: (value) {
                  productName = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.isUpdate ? productDescription : '',
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                ),
                onSaved: (value) {
                  productDescription = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.isUpdate ? productQuantity.toString() : '',
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        productQuantity = int.tryParse(value ?? '0') ?? 0;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: quantityType,
                      decoration: const InputDecoration(
                        labelText: 'Quantity Type',
                      ),
                      items: quantityTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          quantityType = value ?? 'KG';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.isUpdate ? widget.product.price.toString() : '',
                decoration: const InputDecoration(
                  labelText: 'Product Price',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) {
                  productPrice = double.tryParse(value ?? '0') ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),
              _image != null
                  ? InkWell(
                onTap: getImage,
                child: Image.file(
                  _image!,
                  height: 400, // Responsive height
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
                  : InkWell(
                onTap: getImage,
                child: widget.isUpdate && widget.product.imageUrl!.isNotEmpty
                    ? Image.network(
                  widget.product.imageUrl!,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.fill,
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pick Image",
                      style: TextStyle(fontSize: 23, color: Colors.grey),
                    ),
                    Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.1 * MediaQuery.of(context).size.width),
                child: ElevatedButton(
                    onPressed: isLoading ? () {} : _saveProduct,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: isLoading
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            color: Colors.yellow.shade200,
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator(color: Colors.black,)),
                        const SizedBox(width: 5,),
                        const Text('Loading',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.isUpdate ? "Update" : "Save",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
