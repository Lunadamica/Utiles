import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText, borderEnabled;
  final double fontSize;
  final void Function(String text)? onChanged;
  final void Function()? onPressed;
  final String? Function(String? text)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;
  final TextEditingController? controlador;

  const InputText(
      {Key? key,
      this.label = '',
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.borderEnabled = true,
      this.fontSize = 15,
      this.onChanged,
      this.validator,
      this.suffixIcon,
      this.onPressed,
      this.onFieldSubmitted,
      this.controlador})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      onFieldSubmitted: this.onFieldSubmitted,
      //define de que tipo es el texto
      keyboardType: this.keyboardType,
      //ocultamos la contraseña
      obscureText: this.obscureText,
      //cogemos el valor que se inserta en el campo
      onChanged: this.onChanged,
      validator: this.validator,
      style: TextStyle(fontSize: this.fontSize),
      decoration: InputDecoration(
          suffixIcon: this.suffixIcon,
          labelText: this.label,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          enabledBorder: this.borderEnabled
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12))
              : InputBorder.none,
          labelStyle: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}
