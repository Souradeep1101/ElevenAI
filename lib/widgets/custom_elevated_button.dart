import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color textColor;
  final bool isLoading;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor = Colors.white,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    final buttonContent = widget.isLoading
        ? Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.textColor,
                ),
              ),
            ),
        )
        : Center(child: Text(widget.text));

    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: widget.textColor,
        backgroundColor: (widget.color != null)
            ? widget.color
            : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: SizedBox(
        width: double.infinity,
        child: buttonContent,
      ),
    );
  }
}
