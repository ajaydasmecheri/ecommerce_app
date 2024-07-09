import 'package:easybuy/components/timeline.dart';
import 'package:flutter/material.dart';

class Trackorder extends StatelessWidget {
  const Trackorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking details"),
        backgroundColor: const Color.fromARGB(255, 164, 142, 203),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: ListView(
          children: const [
            // staring
            Mytimelinetile(isFirst: true, isLast: false, isPast: true, textendcard: Text("ORDER PLACED"),),
            // middle
            Mytimelinetile(isFirst: false, isLast: false, isPast: true,textendcard: Text("ORDER SHIPPED"),),
            // end
            Mytimelinetile(isFirst: false, isLast: true, isPast: false,textendcard: Text("ORDER DELIVERED"),)
            
      
          ],
        ),
      ),
    );
  }
}
