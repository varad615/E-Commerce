import 'package:flutter/material.dart';
import 'package:v_com/constants.dart';

class CustomInput extends StatelessWidget {
  final String hinttext;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  CustomInput({this.hinttext, this.onChanged, this.onSubmitted, this.focusNode, this.textInputAction, this.isPasswordField});


  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;


    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFADADAD),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hinttext ?? "Hint text...",
            contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
              vertical: 20.0,
        )
        ),
        style: constants.regularDarkText,
      ),
    );
  }
}
