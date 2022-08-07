import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color color;

  const BasicButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color = Colors.lightBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 6,
      onPressed: onPressed,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: child,
    );
  }
}
