import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easybuy/screens/cartpage.dart';
import 'package:easybuy/screens/favorite.dart';
import 'package:easybuy/screens/homepage.dart';
import 'package:easybuy/screens/orders.dart';
import 'package:easybuy/screens/profile.dart';
import 'package:flutter/material.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int pageindex = 0;
 late PageController pagecontroller;
 @override
  void initState() {
   
    super.initState();
    pagecontroller=PageController(initialPage: pageindex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.home), Text("Home")],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.shopping_cart), Text("  Cart  ")],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.favorite), Text(" Favour")],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.card_giftcard_sharp), Text("Orders")],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.person), Text("Profile")],
          )
        ],
        color: const Color.fromARGB(255, 164, 142, 203),
        backgroundColor: Colors.white,
        index: 0,
        onTap: (Index) {
          setState(() {
          pageindex=Index;
          pagecontroller.animateToPage(Index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          });
        },
      ),
      body: PageView(
        controller: pagecontroller,
        physics: const NeverScrollableScrollPhysics(),
        children:  const [
          Homepage(),
          CartPage(),
          Favourite(),
          Orders(),
          Profile()
          // Home2(),
        ],
      ),
    );
  }
}
