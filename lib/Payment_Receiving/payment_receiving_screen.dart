import 'package:flutter/material.dart';

class PaymentReceivingScreen extends StatefulWidget {
  @override
  _PaymentReceivingScreenState createState() => _PaymentReceivingScreenState();
}

class _PaymentReceivingScreenState extends State<PaymentReceivingScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _paymentMethodController = TextEditingController();

  final List<String> _paymentMethods = ['Cash', 'Card', 'UPI', 'Net Banking'];

  bool isLoading = false;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05 * MediaQuery.of(context).size.width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 0.03 * MediaQuery.of(context).size.height),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Normal border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.black, // Color of the border when focused
                        width: 2.0, // Optional: Adjust the width of the focused border
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.03 * MediaQuery.of(context).size.height),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Normal border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.black, // Color of the border when focused
                        width: 2.0, // Optional: Adjust the width of the focused border
                      ),
                    ),
                  ),
                  value: _paymentMethodController.text.isEmpty
                      ? null
                      : _paymentMethodController.text,
                  items: _paymentMethods.map((method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _paymentMethodController.text = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.03 * MediaQuery.of(context).size.height),
                child: TextFormField(
                  controller: _notesController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Normal border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.black, // Color of the border when focused
                        width: 2.0, // Optional: Adjust the width of the focused border
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.03 * MediaQuery.of(context).size.height),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      _receivePayment();
                    },
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
                        : const Text('Receive Payment',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _receivePayment() {
    String amount = _amountController.text;
    String paymentMethod = _paymentMethodController.text;
    String notes = _notesController.text;

    // Here you can add your logic to handle the payment receiving action
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Received'),
          content: Text('Amount: ₹$amount\nPayment Method: $paymentMethod\nNotes: $notes'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
