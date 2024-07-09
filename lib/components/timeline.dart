import 'package:easybuy/components/endcard.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Mytimelinetile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final textendcard;

  const Mytimelinetile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast, this.textendcard});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        //  decorations
        beforeLineStyle:
             LineStyle( color: isPast ? const Color.fromARGB(255, 164, 142, 203): Colors.black12),
        indicatorStyle: IndicatorStyle(
            width: 40,
            color: isPast ? Colors.lightGreen : Colors.lightGreen.shade100,
            iconStyle: IconStyle(iconData: Icons.done, color: Colors.white)),


            //  text adding endcard
            endChild:Endcard(isPast: isPast,
            child: textendcard,)
      ),
    );
  }
}
