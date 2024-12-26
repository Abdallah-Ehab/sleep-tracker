import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  void Function()? onPressed;
  String text;
  double width;
  double height;
  MyButton({super.key,required this.onPressed,required this.text,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        
        child: Text(text,style: const TextStyle(fontFamily: "Arial",fontSize: 16,color: Colors.white),),
      ),
    );
  }
}