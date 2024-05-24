import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final bool showOutlineBorder;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  const MyTextFormField(
      {super.key,
      this.controller,
      this.maxLines = 1,
      this.validator,
      this.onSaved,
      this.prefixIcon,
      this.suffixIcon,
      this.labelText,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.showOutlineBorder = true,
      this.onFieldSubmitted,
      this.focusNode});

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextFormField(
      controller: controller,
      enabled: true,
      focusNode: focusNode,

      autofocus: false,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: false,
      maxLines: maxLines,
      enableSuggestions: true,
      // style: Styles.displayMedNormalStyle,
      decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          // isCollapsed: true,
          fillColor: AppColors.textFormFieldFillColor,
          filled: true,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: showOutlineBorder
              ? const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                )
              : InputBorder.none,
          // isCollapsed: true,

          focusColor: Theme.of(context).primaryColor,
          // hintStyle: Styles.displaySmNormalStyle,
          hintText: labelText ?? 'Search',
          floatingLabelBehavior: FloatingLabelBehavior.never),

      style: Theme.of(context).textTheme.bodyMedium,

      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      cursorColor: Theme.of(context).focusColor,
      // Add any additional properties or configurations here
    );
  }
}
