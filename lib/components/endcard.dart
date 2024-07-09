import 'package:flutter/material.dart';

class Endcard extends StatelessWidget {
  final bool isPast;
  final child;

  const Endcard({super.key, required this.isPast, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: isPast ? Colors.green : Colors.green.shade100,
          borderRadius: BorderRadius.circular(15)),
      child:child,
    );
  }
}
