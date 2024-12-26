import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  GestureTapCallback? onTap;
  String hint;
  MyTextField({super.key,required this.onTap,required this.hint});

  @override
  Widget build(BuildContext context) {
    return  TextField(
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: "Arial",
          fontSize: 16.0,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.black
          )
        )
      ),
    );
  }
}