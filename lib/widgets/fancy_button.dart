import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {
  const FancyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.blue,
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.deepOrangeAccent,
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'testing',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(50),
    );
  }
}
