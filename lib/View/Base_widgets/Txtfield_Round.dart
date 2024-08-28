import 'package:flutter/material.dart';

class TextField_Round extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  bool? obscureText = false;
  final Icon? prefixIcon;
  final int? maxlines;
  final IconData? sufixIcon;
  final TextInputType? keyType;
  final Function(String)? onChanged;
  final Function()? suffixIconPress;
  final String? Function(String?)? validator;

  TextField_Round({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    this.prefixIcon,
    this.sufixIcon,
    this.keyType,
    this.maxlines = 1,
    this.onChanged,
    this.suffixIconPress,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).hintColor,
      ),
      child: TextFormField(
        maxLines: maxlines,
        keyboardType: keyType,
        controller: controller,
        obscureText: obscureText ?? false,
        cursorColor: Theme.of(context).hintColor,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Theme.of(context).canvasColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          hintStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).hintColor,
            fontSize: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIcon: prefixIcon,
          prefixIconColor: Theme.of(context).hintColor,
          filled: true,
          suffixIcon: sufixIcon != null
              ? IconButton(
                  onPressed: suffixIconPress,
                  icon: Icon(
                    sufixIcon,
                    color: Theme.of(context).hintColor,
                  ),
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
