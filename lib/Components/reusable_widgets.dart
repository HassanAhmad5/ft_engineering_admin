import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  IconData icon;
  String text;
  final Function() onTap;
  ReusableContainer({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset : Offset(0, -3)
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, size: 45,),
              const SizedBox(height: 5,),
              Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16
                ),),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableButton extends StatelessWidget {
  String text;
  final Function() onPressed;
  ReuseableButton({super.key, required this.text, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.1 * MediaQuery.of(context).size.width),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          )
      ),
    );
  }
}

