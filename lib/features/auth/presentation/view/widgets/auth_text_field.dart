import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(String)? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.onChanged,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _passwordVisibility = false;
  Color _iconColor = Colors.grey.shade400;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _passwordVisibility = widget.obscureText;
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _iconColor = _focusNode.hasFocus ? Colors.black : Colors.grey.shade400;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        controller: widget.controller,
        obscureText: _passwordVisibility,
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(25.0),
          ),
          suffixIcon: widget.obscureText
              ? Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    splashFactory: InkRipple.splashFactory,
                    splashColor: Colors.grey.withValues(),
                    radius: 15,
                    onTap: () => setState(() {
                      _passwordVisibility = !_passwordVisibility;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        _passwordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: _iconColor,
                        size: 18,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }
}
